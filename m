Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128E225F97F;
	Tue,  1 Jul 2025 20:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751402767; cv=none; b=td9LXs3FK8pbnJu+BVEGb4IjnJnlrkCCQ/cIf/TthDliIDeU8T9yMRvcEOzp9F+z2qTJIyEJn8SPLK335LNbEQjkkTW0gYzL5jwMhw5oV/l2tAGfhDcE+Js3NUMmvYiv3sQJ0JdUNWys/355V7uelpu+Vp3xpKyKbrV14lvm8jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751402767; c=relaxed/simple;
	bh=PPuAHOh3dZj7mhkDNq3If+vUzbU+xhacUxUvLBZaUfU=;
	h=Date:To:From:Subject:Message-Id; b=QEfmz3FeS17DQT53wlyhBDfL2MX8WeL4FFdJiLW30rNHFISCxvd/Uyod4S+00Gndr/JK+iohBZlM+Z19FvbnZJX2mb1VmRkI2/CpS2fvPQKZrsX73JMTYX7uKK8cI8Wm3TrxuMPM13I/A+UNVj8wdt7etAqn2tx7c0xtoUOwfqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w8Fhvl3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w8Fhvl3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77395C4CEF1;
	Tue,  1 Jul 2025 20:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751402766;
	bh=PPuAHOh3dZj7mhkDNq3If+vUzbU+xhacUxUvLBZaUfU=;
	h=Date:To:From:Subject:From;
	b=w8Fhvl3vDEvq9sees4wKVmfeWu/oVLW45kw1HqhK4DTMprBJyLEp7EZPgJVGLu+2B
	 tM0q9xe+VZwJ3qjhcveQ5uLIPq4YbVr3rZbuDYioVBGOx22JOORJnB3m9rTiJCl3Mv
	 f5EeftldvhZUPi63zcvoA1VnvmOee1rJpoC3oDyg=
Date: Tue, 01 Jul 2025 13:46:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,bertranddrouvot.pg@gmail.com,apopple@nvidia.com,myon@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fix-do_pages_stat-to-use-compat_uptr_t.patch removed from -mm tree
Message-Id: <20250701204606.77395C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate.c: fix do_pages_stat to use compat_uptr_t
has been removed from the -mm tree.  Its filename was
     fix-do_pages_stat-to-use-compat_uptr_t.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Christoph Berg <myon@debian.org>
Subject: mm/migrate.c: fix do_pages_stat to use compat_uptr_t
Date: Wed, 25 Jun 2025 17:24:14 +0200

For arrays with more than 16 entries, the old code would incorrectly
advance the pages pointer by 16 words instead of 16 compat_uptr_t.

[akpm@linux-foundation.org: fix coding style]
Link: https://lkml.kernel.org/r/aFwUnu7ObizycCZ8@msg.df7cb.de
Signed-off-by: Christoph Berg <myon@debian.org>
Suggested-by: Bertrand Drouvot <bertranddrouvot.pg@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~fix-do_pages_stat-to-use-compat_uptr_t
+++ a/mm/migrate.c
@@ -2444,7 +2444,14 @@ static int do_pages_stat(struct mm_struc
 		if (copy_to_user(status, chunk_status, chunk_nr * sizeof(*status)))
 			break;
 
-		pages += chunk_nr;
+		if (in_compat_syscall()) {
+			compat_uptr_t __user *pages32 = (compat_uptr_t __user *)pages;
+
+			pages32 += chunk_nr;
+			pages = (const void __user * __user *) pages32;
+		} else {
+			pages += chunk_nr;
+		}
 		status += chunk_nr;
 		nr_pages -= chunk_nr;
 	}
_

Patches currently in -mm which might be from myon@debian.org are


