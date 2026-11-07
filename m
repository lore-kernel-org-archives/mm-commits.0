Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794079453;
	b=VYzbB4wK4eV5OqmjxE17uUI+cyt2gob9vEK+nY0MDI17o6dNHptzCz98MFpVR0janptM
	 fHJ55/5QO+leCnsMjcLWJWlRiEhiPX4DgNcgnZEdbZz25EeGqHPdFscRtsxQdZg+luKI/
	 8+ijr3SPXFc/pLhMpQ04IYah29ATi9UCE0Pwiy+WfHM0WCeuNks479XTnC0mwar3rFw3C
	 l2QFBkVOIYngZrLRR9tVZG8fAzbbPj5xwo1qiohB5Tudc/vdEy4HrrIYidyxEB3hZDK1q
	 l9Yo7xlklOgtbQjDG8ygOtWfTgRv+ZtUDh0tR+taiqHA7p7dAciGWw6r8Zm2TmCZ5tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794079453;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=wxY8a8dTwf051gMI0dZF5734jIkEYaONcfr0G6I9q8I=;
	b=klZeUDTud4zzCORW1IIIchIUV1xi/FcJZipVhdx5Y7ISjrm0fmTVkV+KBLJgolK+6TmK
	 H/5IQ99fPgrOOHauku23sJs38UoHtCUErWBmZgNqIDkQvdGKfLFSOrwKny/7XeOidhf8s
	 gtuOrsC1KS+jwOHd7CU2Leki7bBLmSp2eoC3RhZendXR+ginYstxT17ZZD1MOLpUw5YU8
	 OVb2NG7twbomuR4Q1SE6CJSueJVJSFlTlAm11NUEORuoMqNmcvEBI/wqfLKHgci3qpBAj
	 J0jN7ttfde1J/5Jedd4rDuuoJ2x5XSTfmQcWGiDiFJnyWdAdS6NBi2HU+y1e88PBmmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1eXxV8tq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA87606A326
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 19:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1eXxV8tq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2921F0089F;
	Sat,  7 Nov 2026 19:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794079452;
	bh=wxY8a8dTwf051gMI0dZF5734jIkEYaONcfr0G6I9q8I=;
	h=Date:To:Cc:From:Subject;
	b=1eXxV8tqDR5yZGmIlMB9lRYu71bWJY0XnbvJDp5BNEWdvstYg8//AaoM4qmG23TP1
	 YGgAyu77qYioTLudOMlykTHvsFNkD4lJfbdFt6NmC+Sg1mqniOFMVtG6poLDYwpiVP
	 TnhCtq6LJxdkFFqhQW8bwSt1B/stb3RhiNdhwFo4=
Date: Sat, 07 Nov 2026 11:24:11 -0800
To: mm-commits@vger.kernel.org, xiqi2@huawei.com, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-migrate-fix-softlockup-in-do_pages_stat-with-huge-page-arrays.patch removed from -mm tree
Message-Id: <20261107192412.6A2921F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/migrate: fix softlockup in do_pages_stat() with huge page arrays
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-softlockup-in-do_pages_stat-with-huge-page-arrays.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qi Xi <xiqi2@huawei.com>
Subject: mm/migrate: fix softlockup in do_pages_stat() with huge page arrays
Date: Sat, 31 Oct 2026 11:33:30 +0800

do_pages_stat() walks the user page array in 16-page chunks but never
reschedules, so a huge nr_pages can hold a CPU past the watchdog threshold
on non-preemptible kernels.  Add cond_resched() to the loop so long
move_pages() node-query calls yield periodically.

With KASAN and function tracing enabled, a move_pages() node query (nodes
== NULL) over 10 million page entries (~40GB) can trigger the softlockup
on a PREEMPT_NONE kernel.

Link: https://lore.kernel.org/20261031033330.3416326-1-xiqi5703@163.com
Fixes: 80bba1290ab5 ("mm: no get_user/put_user while holding mmap_sem in do_pages_stat?")
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: <stable@vger.kernel.org>
---

 mm/migrate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/migrate.c~mm-migrate-fix-softlockup-in-do_pages_stat-with-huge-page-arrays
+++ a/mm/migrate.c
@@ -2555,6 +2555,7 @@ static int do_pages_stat(struct mm_struc
 
 		chunk_offset += chunk_nr;
 		nr_pages -= chunk_nr;
+		cond_resched();
 	}
 	return nr_pages ? -EFAULT : 0;
 }
_

Patches currently in -mm which might be from xiqi2@huawei.com are


