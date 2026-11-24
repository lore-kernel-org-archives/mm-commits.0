Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537132;
	b=esrteS+KlTW3Mw7juDQV63xnQjEa5jx03Vf7DeYbN5L5kAGlMMWo7yLHNSzi29n0UtPi
	 tRRZjsN2schAm8fs8EvEL24OLfA4krnvtLyAREKyPkw0YcZ7Mgsfd2Ho9fJj9avId5qz3
	 yoDMG2TRP46iByXzNr4y/PFt+zZnHFFT9tV6bwS2o/fKTkV9vQR9xNet5oe2i90LBhdDx
	 7f6ms8+3XAQMxM1PWs9rLxP4Iq3BNo86HhPr7V8Py3f4t3F1CXXw3sNtMjTWQIhvauyhv
	 WUDvwjpYAUHc0kOri37ds7TizsVnWE42dLb6JC9d82XE8ifryRHSUv4otT/Bl+MHXYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537132;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=XiUPWFu8tBAZXX3FfwvjKy16oiDJTvYwElmUaCKhYo4=;
	b=FEI81lGu6lFovqUBXH/ps+ILH2M+AmCV830TIWKjyDo1vCQ8OilQftDpkrNR6zfIIO9s
	 vWubYZrCm+eaYa4ZMwLUq5LuBnkRc+pcWQ23pURHW8xDw53AmEyy6aO0keAkBxYmkJEDO
	 SmXPcwvia+2zZNi4J2b2/Kzd+gvS2HMvvvyfn37Co4jzctxtYnMZvPE2Zbh5q4JtPj4oA
	 DP9QdyUtNUsaWe6i8TwK4lJ84aueoMOnALaRjwPj0Oe4a1VPPk4dS/9Auri8+4/sRszuk
	 xg2VNxDJ+3z5dK7fRbr+ddDZXh+GH6gO9G0f/U1pvBaHukaL8og/nvY4MOV/p2XIu9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WsEN+WYz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E44606A32C
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 16:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WsEN+WYz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7570E1F000D4;
	Tue, 24 Nov 2026 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795537131;
	bh=XiUPWFu8tBAZXX3FfwvjKy16oiDJTvYwElmUaCKhYo4=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=WsEN+WYzXxSLfJ8NGojwQhVw++JmLL5tRc2bV4yoovjh4UMBRUORqvrp5YHRaQGg5
	 st7qiWwlLM1fLv1nJzvn4IrSeiiyW07xjPjIR7h3pvlAM+j/cm3x93TG6okBae7TVi
	 /5J1yyPOUk1WmhfPIgow8qWMi8YXwPbMAtCqklG8=
Date: Tue, 24 Nov 2026 08:18:51 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yu-cheng.yu@intel.com,
	ying.huang@linux.alibaba.com,willy@infradead.org,vbabka@kernel.org,
	usama.arif@linux.dev,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,
	rppt@kernel.org,rientjes@google.com,rick.p.edgecombe@intel.com,
	pfalcato@suse.de,peng.fan@nxp.com,nphamcs@gmail.com,mhocko@suse.com,
	matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,
	kas@kernel.org,joshua.hahnjy@gmail.com,jglisse@redhat.com,jbacik@fb.com,
	jannh@google.com,jack@suse.cz,hannes@cmpxchg.org,gourry@gourry.net,
	dennisszhou@gmail.com,dennis@kernel.org,david@kernel.org,
	dave.hansen@linux.intel.com,cl@gentwo.org,chris@chrisdown.name,
	byungchul@sk.com,broonie@kernel.org,bp@alien8.de,balbirs@nvidia.com,
	apopple@nvidia.com,mason@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-13-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-13-50a2ed382b61@kernel.org>
Subject: + percpu-queue-the-balance-work-on-an-unbound-workqueue.patch added to mm-unstable branch
Message-Id: <20261124161851.7570E1F000D4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: percpu: queue the balance work on an unbound workqueue
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-queue-the-balance-work-on-an-unbound-workqueue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-queue-the-balance-work-on-an-unbound-workqueue.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Chris Mason <mason@kernel.org>
Subject: percpu: queue the balance work on an unbound workqueue
Date: Fri, 13 Nov 2026 21:45:31 +0000

A burst of small atomic per-CPU allocations can fail with -ENOMEM while the
machine has free memory and idle CPUs, as atomic per-CPU allocations are
only served from pages that are already populated, and those can be used up
before a worker gets to populate more.

Consider:

    caller on CPU 1                     kworker bound to CPU 1
    ===============                     ======================
    allocates 8 bytes, which leaves
    one empty page and 4088 bytes
      schedule_work()                   woken, waits for CPU 1
    allocates 8 bytes, 1023 times
    next allocation: "no space left"
    gives up CPU 1                      populates pages

The allocator keeps a few empty populated pages in reserve, and the work
item pcpu_balance_work refills them.

pcpu_alloc_noprof() queues the work item using schedule_work(), so only a
worker bound to the CPU of the caller can run the work item.

The issue is that the caller keeps that CPU - a task keeps it for the rest
of its time slice, and a softirq keeps it until the softirq ends.

In that time the caller can use up the reserve, resulting in an atomic
per-CPU allocation failing.

Fix the issue by queueing the work item on an unbound workqueue so that
another CPU can populate pages while the caller keeps allocating.

Gregory Price hammered atomic per-CPU allocations from one CPU with
preemption disabled for about a second, with and without this series:

                           Before     After
    Successful allocs       1,188   131,072
    Failed allocs           4,097         0
    Balance worker runs         0       169
    Successful retries          0     4,096

[ljs@kernel.org: tweaked commit message, comment]
Link: https://patch.msgid.link/20261113-mason-migrate-et-al-fixes-v2-13-50a2ed382b61@kernel.org
Fixes: 1a4d76076cda ("percpu: implement asynchronous chunk population")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Yu, Yu-cheng <yu-cheng.yu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Dennis Zhou (Facebook) <dennisszhou@gmail.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>

 mm/percpu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/percpu.c~percpu-queue-the-balance-work-on-an-unbound-workqueue
+++ a/mm/percpu.c
@@ -200,8 +200,9 @@ static bool pcpu_atomic_alloc_failed;
 
 static void pcpu_schedule_balance_work(void)
 {
+	/* Unbound, so another CPU can populate pgs if caller keeps this one. */
 	if (pcpu_async_enabled)
-		schedule_work(&pcpu_balance_work);
+		queue_work(system_dfl_wq, &pcpu_balance_work);
 }
 
 /**
_

Patches currently in -mm which might be from mason@kernel.org are

mm-swap-fix-large-swap-in-across-swap-file-extents.patch
hugetlbfs-do-not-grow-a-sealed-file-in-mmap.patch
mm-hugetlb-keep-surplus-folios-that-are-reserved.patch
mm-hugetlb-fix-reservation-leak-on-min_size=-mounts.patch
mm-cachestat-count-each-page-only-once.patch
mm-cachestat-restart-the-walk-after-each-entry.patch
percpu-queue-the-balance-work-on-an-unbound-workqueue.patch

