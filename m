Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63F026AC7
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 14:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839EDC433C8;
	Wed, 13 Dec 2023 14:43:59 +0000 (UTC)
Date: Wed, 13 Dec 2023 09:44:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Bixuan Cui <cuibixuan@vivo.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 opensource.kernel@vivo.com
Subject: Re: [PATCH -next v2 1/2] mm: shrinker: add new event to trace
 shrink count
Message-ID: <20231213094443.010889a4@gandalf.local.home>
In-Reply-To: <20231213063330.3208-2-cuibixuan@vivo.com>
References: <20231213063330.3208-1-cuibixuan@vivo.com>
	<20231213063330.3208-2-cuibixuan@vivo.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 12 Dec 2023 22:33:29 -0800
Bixuan Cui <cuibixuan@vivo.com> wrote:

> From: cuibixuan <cuibixuan@vivo.com>
> 
> do_shrink_slab() calculates the freeable memory through shrinker->count_objects(),
> and then reclaims the memory through shrinker->scan_objects(). When reclaiming
> memory, shrinker->count_objects() takes a certain amount of time:
> 
> 	Fun               spend(us)
> 	ext4_es_count     4302
> 	ext4_es_scan      12
> 	super_cache_count 4195
> 	super_cache_scan  2103
> 
> Therefore, adding the trace event to count_objects() can more accurately
> obtain the time taken for slab memory recycling.
> 
> Example of output:
>          kswapd0-103     [003] .....  1098.317942: mm_shrink_count_start: kfree_rcu_shrink_count.cfi_jt+0x0/0x8 00000000c540ff51: nid: 0
>          kswapd0-103     [003] .....  1098.317951: mm_shrink_count_end: kfree_rcu_shrink_count.cfi_jt+0x0/0x8 00000000c540ff51: nid: 0 freeable:36
> 
> Signed-off-by: Bixuan Cui <cuibixuan@vivo.com>
> ---
>  include/trace/events/vmscan.h | 49 +++++++++++++++++++++++++++++++++++
>  mm/shrinker.c                 |  4 +++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> index 1a488c30afa5..406faa5591c1 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -196,6 +196,55 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_re
>  );
>  #endif /* CONFIG_MEMCG */
>  
> +TRACE_EVENT(mm_shrink_count_start,
> +	TP_PROTO(struct shrinker *shr, struct shrink_control *sc),
> +
> +	TP_ARGS(shr, sc),
> +
> +	TP_STRUCT__entry(
> +		__field(struct shrinker *, shr)
> +		__field(void *, shrink)
> +		__field(int, nid)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->shr = shr;
> +		__entry->shrink = shr->count_objects;
> +		__entry->nid = sc->nid;
> +	),
> +
> +	TP_printk("%pS %p: nid: %d",
> +		__entry->shrink,
> +		__entry->shr,
> +		__entry->nid)
> +);
> +
> +TRACE_EVENT(mm_shrink_count_end,
> +	TP_PROTO(struct shrinker *shr, struct shrink_control *sc, long freeable),
> +
> +	TP_ARGS(shr, sc, freeable),
> +
> +	TP_STRUCT__entry(
> +		__field(struct shrinker *, shr)
> +		__field(void *, shrink)

> +		__field(int, nid)

int :  4 bytes

> +		__field(long, freeable)

long: 8 bytes


You may want to swap the above, otherwise you added a hole in the trace
event. The compiler will add 4 bytes of padding between 'nid' and
'freeable'. That is, if you change it to:

	TP_STRUCT__entry(
		__field(struct shrinker *, shr)
		__field(void *, shrink)
		__field(long, freeable)
		__field(int, nid)

You will save 4 bytes per event in the ring buffer.

-- Steve



> +	),
> +
> +	TP_fast_assign(
> +		__entry->shr = shr;
> +		__entry->shrink = shr->count_objects;
> +		__entry->nid = sc->nid;
> +		__entry->freeable = freeable;
> +	),
> +
> +	TP_printk("%pS %p: nid: %d freeable:%ld",
> +		__entry->shrink,
> +		__entry->shr,
> +		__entry->nid,
> +		__entry->freeable)
> +);
> +
>  TRACE_EVENT(mm_shrink_slab_start,
>  	TP_PROTO(struct shrinker *shr, struct shrink_control *sc,
>  		long nr_objects_to_shrink, unsigned long cache_items,
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index dd91eab43ed3..d0c7bf61db61 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -379,7 +379,11 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
>  					  : SHRINK_BATCH;
>  	long scanned = 0, next_deferred;
>  
> +	trace_mm_shrink_count_start(shrinker, shrinkctl);
> +
>  	freeable = shrinker->count_objects(shrinker, shrinkctl);
> +
> +	trace_mm_shrink_count_end(shrinker, shrinkctl, freeable);
>  	if (freeable == 0 || freeable == SHRINK_EMPTY)
>  		return freeable;
>  

