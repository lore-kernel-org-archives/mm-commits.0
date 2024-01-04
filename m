Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837F724B31
	for <mm-commits@vger.kernel.org>; Thu,  4 Jan 2024 16:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C1AC433C8;
	Thu,  4 Jan 2024 16:31:43 +0000 (UTC)
Date: Thu, 4 Jan 2024 11:32:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Bixuan Cui <cuibixuan@vivo.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 opensource.kernel@vivo.com
Subject: Re: [PATCH -next v5 2/2] mm: vmscan: add new event to trace shrink
 lru
Message-ID: <20240104113248.00101ab9@gandalf.local.home>
In-Reply-To: <20240104100145.3855-3-cuibixuan@vivo.com>
References: <20240104100145.3855-1-cuibixuan@vivo.com>
	<20240104100145.3855-3-cuibixuan@vivo.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu,  4 Jan 2024 02:01:45 -0800
Bixuan Cui <cuibixuan@vivo.com> wrote:

> From: cuibixuan <cuibixuan@vivo.com>
>=20
> Page reclaim is an important part of memory reclaim, including:
>   * shrink_active_list(), moves folios from the active LRU to the inactiv=
e LRU
>   * shrink_inactive_list(), shrink lru from inactive LRU list
>=20
> Add the new events to calculate the execution time to better evaluate=20
> the entire memory recycling ratio.
>=20
> Example of output:
>          kswapd0-103     [007] .....  1098.353020: mm_vmscan_lru_shrink_a=
ctive_start: nid=3D0
>          kswapd0-103     [007] .....  1098.353040: mm_vmscan_lru_shrink_a=
ctive_end: nid=3D0 nr_taken=3D32 nr_active=3D0 nr_deactivated=3D32 nr_refer=
enced=3D0 priority=3D6 flags=3DRECLAIM_WB_FILE|RECLAIM_WB_ASYNC
>          kswapd0-103     [007] .....  1098.353040: mm_vmscan_lru_shrink_i=
nactive_start: nid=3D0
>          kswapd0-103     [007] .....  1098.353094: mm_vmscan_lru_shrink_i=
nactive_end: nid=3D0 nr_scanned=3D32 nr_reclaimed=3D0 nr_dirty=3D0 nr_write=
back=3D0 nr_congested=3D0 nr_immediate=3D0 nr_activate_anon=3D0 nr_activate=
_file=3D0 nr_ref_keep=3D32 nr_unmap_fail=3D0 priority=3D6 flags=3DRECLAIM_W=
B_ANON|RECLAIM_WB_ASYNC
>          kswapd0-103     [007] .....  1098.353094: mm_vmscan_lru_shrink_i=
nactive_start: nid=3D0
>          kswapd0-103     [007] .....  1098.353162: mm_vmscan_lru_shrink_i=
nactive_end: nid=3D0 nr_scanned=3D32 nr_reclaimed=3D21 nr_dirty=3D0 nr_writ=
eback=3D0 nr_congested=3D0 nr_immediate=3D0 nr_activate_anon=3D0 nr_activat=
e_file=3D0 nr_ref_keep=3D11 nr_unmap_fail=3D0 priority=3D6 flags=3DRECLAIM_=
WB_FILE|RECLAIM_WB_ASYNC
>=20
> Signed-off-by: Bixuan Cui <cuibixuan@vivo.com>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> Changes:
> v5: * Use 'DECLARE_EVENT_CLASS(mm_vmscan_lru_shrink_start_template' to
> replace 'RACE_EVENT(mm_vmscan_lru_shrink_inactive/active_start'
>     * Add the explanation for adding new shrink lru events into 'mm: vmsc=
an: add new event to trace shrink lru'

=46rom the tracing POV:

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

> v4: * Add Reviewed-by and Changlog to every patch.
> v3: * Swap the positions of 'nid' and 'freeable' to prevent the hole in t=
he trace event.
> v2: * Modify trace_mm_vmscan_lru_shrink_inactive() in evict_folios() at t=
he same time to fix build error (Andrew pointed out).
>=20
>  include/trace/events/vmscan.h | 31 +++++++++++++++++++++++++++++--
>  mm/vmscan.c                   | 11 ++++++++---
>  2 files changed, 37 insertions(+), 5 deletions(-)
>=20
