Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795405707;
	b=oVn9QHUSQbifeNPF2dveV9O0rNrxT4JQat9tnWS7qLmVrORksrr4jhdmXk6mia6InQFl
	 WClgNVI0/c82ZwKuDRvgAWrq5/kIkQBO0NAwU4COakkbSTdpv3YiMFNqol8eAA/B1UkHl
	 s+22gfPfPS+urfdYhNudqaHCVQm7XDJw2nyDBfgSBSy5/8DTTM/TKQF7r6fM+2MasRJoB
	 PuQZPwCSOfE9qsQ8iwSSgKxDo1cOAq0revwGYycELmT5116bsJCZW/TqjkN6zCBdXBw+a
	 eXzwyWjw+EmeXax7YfeNlKlMPbMCm5EZy1ubFgToTrctEHt2W0iiGu0FGS70v+X1ITA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795405707;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=4ixwLYNHrzYtUov5QUyLh0SBuMoy5xQNhmCQu9M+e0U=;
	b=NzacN+cZphchZUTnHJ5BYh5V2TxVsdAAkBxsKqd8qbjwW04hFvHF6lwRdOyVvTSfwKZ8
	 PZVNnhynBMkR0lYFCuQesI2my69U0/pIjcJ2c+hgX8wXkKEgiZZhckTMau/4tFCwQ4YqL
	 yx0Wjf3uULBWuuzq+IrknPQW3GRCA+h2RptRu60pl0/pxvfoqISgo70hGdwVmJTCfNV3x
	 WtWV+NOFDBJQW0nWNrItnfCMB/BWHLPZMd3jtVHUoKbdw6ErFLnlRnnFyLoVqm3U9Zv+P
	 LI95ixcU8vLLOgE/fKVZF5+ndZ2IYUE1/qQQeXe2q3cRaAkmA8VHT3B19USNfreSvKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SQPSg2UH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A023606A31A;
	Mon, 23 Nov 2026 03:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SQPSg2UH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCB21F000CA;
	Mon, 23 Nov 2026 03:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795405706;
	bh=4ixwLYNHrzYtUov5QUyLh0SBuMoy5xQNhmCQu9M+e0U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SQPSg2UHPTiaBzka5y0mmvvcTp3eQnHFgEXA7m0SMy9eRlCqM6kIwVvhacMrOZOG+
	 bGJN9vKoFa04CpsE6GqWRbd00xIF+BlY8+1VrdQtHwWbZUJvpV3fUoXTEJAhJjtm/u
	 F6AIt0IcMleoKcGSPOOhw0j2BZ0fpRHAA6JzsyE4=
Date: Sun, 22 Nov 2026 19:48:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
 David Rientjes <rientjes@google.com>
Subject: Re: [akpm-mm:mm-unstable 327/327]
 arch/arm64/include/asm/percpu.h:261:1: sparse: sparse: cast truncates bits
 from constant value (ffffffffffffd8f0 becomes f0)
Message-Id: <20261122194825.2541c7389c2f958ef3d07fbc@linux-foundation.org>
In-Reply-To: <20261121133112.48w1QOqw-lkp@intel.com>
References: <20261121133112.48w1QOqw-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 21 Nov 2026 13:34:45 +0100 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   7d1a16abe4cc5dccd21e3d6262e44433a5885d27
> commit: 7d1a16abe4cc5dccd21e3d6262e44433a5885d27 [327/327] mm: vmstat_kunit: add synthetic benchmark for mm stats
> config: arm64-randconfig-r2305-20261121 (https://download.01.org/0day-ci/archive/20261121/20261121133112.48w1QOqw-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 15.3.0
> sparse: v0.6.5-rc1-21-g84ec0658
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261121/20261121133112.48w1QOqw-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/20261121133112.48w1QOqw-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
>    mm/tests/vmstat_kunit.c: note: in included file (through include/linux/irqflags.h, include/linux/spinlock.h, include/linux/kref.h, include/kunit/test.h):
> >> arch/arm64/include/asm/percpu.h:261:1: sparse: sparse: cast truncates bits from constant value (ffffffffffffd8f0 becomes f0)

Thanks.  sparse is being a bit silly here.  Using a variable instead of
a constant silences it.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/vmstat_kunit: avoid sparse warning in vm event cleanup
Date: Sun, 22 Nov 2026 18:51:40 -0800

Sparse warns about -TEST_COUNT in an unreachable 1-byte arm64 per-CPU
case; the actual counter is 8 bytes.  Pass the completed loop count
instead to silence the warning, with no behavior change.

Link: https://lore.kernel.org/r/21183f5b-2697-cbe6-6370-dbd27c5e2b60@google.com
Fixes: 7d1a16abe4cc ("mm: vmstat_kunit: add synthetic benchmark for mm stats")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/20261121133112.48w1QOqw-lkp@intel.com/
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>

 mm/tests/vmstat_kunit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/tests/vmstat_kunit.c~mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix
+++ a/mm/tests/vmstat_kunit.c
@@ -107,7 +107,7 @@ static void vmstat_test_interleaved_zone
 
 /*
  * Test 3: count_vm_event() benchmark.
- * Restores counter balance with count_vm_events(item, -TEST_COUNT).
+ * Restores counter balance after measurement.
  */
 static void vmstat_test_count_vm_event(struct kunit *test)
 {
@@ -124,7 +124,7 @@ static void vmstat_test_count_vm_event(s
 	time2 = get_cycles();
 
 	/* Restore balance */
-	count_vm_events(SLABS_SCANNED, -TEST_COUNT);
+	count_vm_events(SLABS_SCANNED, -(long)i);
 
 	time = time2 - time1;
 	avg_cycles = div_u64(time, TEST_COUNT);
_

