Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E956A19007D
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 03:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741663477; cv=none; b=V77n0bhuMcndKhgafw1cZbnnEeZkGsPepk2igVZsE2xmam1ZRSfwVlSi58/7i6wcJpFM8HImhqkVTWkF4D4EsjKvw8K0zRGks+7YMn8SexUNKFRA1FRhFxYDXp0a67FgBAp1F7T55BYi30n4AwU7u0j9+tZ+AJl1oaqpUneLcaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741663477; c=relaxed/simple;
	bh=GVyz+Yi+sHVIuz6A3miITjTKPIv75l+cIZgtByJhRMw=;
	h=Date:To:From:Subject:Message-Id; b=Moj/IcOlq8kMfpt0zBl4ZewJVrrTehl64vhfwxzLTNI4c2rluUFrhqiouXma+2IbvtZISRrhKX1JFgN1LY7fNscye3XkVe77kfJ/L8Gk8FGgydsaAimSyQTiW/EnyYWQi8y417mBXeTw8BtcngrOwDQ2lsuBXcmqCYiJmAPP5w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dEiXTBP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dEiXTBP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E147C4CEE9;
	Tue, 11 Mar 2025 03:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741663476;
	bh=GVyz+Yi+sHVIuz6A3miITjTKPIv75l+cIZgtByJhRMw=;
	h=Date:To:From:Subject:From;
	b=dEiXTBP9hpyokoF5IVPMJdOqQS4kwGQ+jd3AhqX0hL4oX6DjP7hjsQ0+mURjmZ5te
	 W/l3bAnn6ZBxtKbrCn7ABsuAuf/aowMCme0AOC8ujnQrSH/KnMchbLw6V/BJISRVcw
	 PYHiIRkjNkTT5f3qwjUdx+ATJs/ON8ofOC11oc50=
Date: Mon, 10 Mar 2025 20:24:35 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,gregkh@linuxfoundation.org,david@redhat.com,dakr@kernel.org,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-expose-for_each_present_section_nr.patch added to mm-unstable branch
Message-Id: <20250311032436.3E147C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: expose for_each_present_section_nr()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-expose-for_each_present_section_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-expose-for_each_present_section_nr.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/sparse: expose for_each_present_section_nr()
Date: Tue, 11 Mar 2025 10:46:55 +1000

Patch series "drivers/base/memory: Two cleanups", v2.

The series has two cleanups to drivers/base/memory as below.

PATCH[1-2] Improves add_boot_memory_block() by using for_each_present_section_nr()
           and droping @section_count
PATCH[3]   Corrects the comments to match with 'struct memory_group'


This patch (of 2):

Expose for_each_present_section_nr() to be used by drivers/base/memory
in the next patch.

No functional changes intended.

Link: https://lkml.kernel.org/r/20250311004657.82985-1-gshan@redhat.com
Link: https://lkml.kernel.org/r/20250311004657.82985-2-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 +++++
 mm/sparse.c            |    5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-expose-for_each_present_section_nr
+++ a/include/linux/mmzone.h
@@ -2140,6 +2140,11 @@ static inline unsigned long next_present
 	return -1;
 }
 
+#define for_each_present_section_nr(start, section_nr)		\
+	for (section_nr = next_present_section_nr(start - 1);	\
+	     section_nr != -1;					\
+	     section_nr = next_present_section_nr(section_nr))
+
 /*
  * These are _only_ used during initialisation, therefore they
  * can use __initdata ...  They could have names to indicate
--- a/mm/sparse.c~mm-sparse-expose-for_each_present_section_nr
+++ a/mm/sparse.c
@@ -170,11 +170,6 @@ static void __section_mark_present(struc
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
 
-#define for_each_present_section_nr(start, section_nr)		\
-	for (section_nr = next_present_section_nr(start-1);	\
-	     section_nr != -1;								\
-	     section_nr = next_present_section_nr(section_nr))
-
 static inline unsigned long first_present_section_nr(void)
 {
 	return next_present_section_nr(-1);
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-sparse-expose-for_each_present_section_nr.patch
drivers-base-memory-improve-add_boot_memory_block.patch
drivers-base-memory-correct-the-field-name-in-the-header.patch

