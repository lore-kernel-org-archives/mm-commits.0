Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8991913B58C
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 22:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737066391; cv=none; b=l+D2yb8Wf0gSfWfejPMSUy+s8oTr9RcxaVNkkRelly5NHlZawaE/awA8cQ50labVdl6rFx3wPspTRK8NO7BGdvcDT7UtjQWiJVZ8TF1iFYrccw8Nz5IqCc2mrgugzdpupTnXY/sQBWQ58sas8p6id2SF0n42lgh6YBLNnbXSxvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737066391; c=relaxed/simple;
	bh=gglgTsamVE3pE6IrYsR3rUYa+RdfrSCHsDhOa8Ss6t8=;
	h=Date:To:From:Subject:Message-Id; b=GyVMbzIKPIlfsKAipNUuS1VMJ3cf+B+Y9dWJQ6kREP1T9bd5lyGdZKS3qWGnpSU/bfYW7FxqNrKxCrmWvtGxc68ksdHVAwi2Wzu50TpMZse6dfTXu5XcoJPHdLjgycaSINZOIeutzm/3K8aLugm5H+x8wOzBnH0aF5vJzRMnlrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uRP0vObf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uRP0vObf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E465EC4CED6;
	Thu, 16 Jan 2025 22:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737066391;
	bh=gglgTsamVE3pE6IrYsR3rUYa+RdfrSCHsDhOa8Ss6t8=;
	h=Date:To:From:Subject:From;
	b=uRP0vObfB9lywQ6pZs4MK2p4DvTEasZrIbJKpsLF5hvMr7jfxwe0N2V0254YH1kI/
	 GbC0UIay5ReSB2cukNZK2I66686MY9d10HPP5Zyihf9B0WazQilQSFIrXKRESblmgA
	 xBEqMK9Rmv/IjljDWkccLhLSPMvFnbTPdCgqukHI=
Date: Thu, 16 Jan 2025 14:26:30 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,anshuman.khandual@arm.com,andreyknvl@gmail.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-sw_tags-use-str_on_off-helper-in-kasan_init_sw_tags.patch added to mm-unstable branch
Message-Id: <20250116222630.E465EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: sw_tags: use str_on_off() helper in kasan_init_sw_tags()
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-sw_tags-use-str_on_off-helper-in-kasan_init_sw_tags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-sw_tags-use-str_on_off-helper-in-kasan_init_sw_tags.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: kasan: sw_tags: use str_on_off() helper in kasan_init_sw_tags()
Date: Thu, 16 Jan 2025 07:24:04 +0100

Remove hard-coded strings by using the str_on_off() helper function.

Link: https://lkml.kernel.org/r/20250116062403.2496-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/sw_tags.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kasan/sw_tags.c~kasan-sw_tags-use-str_on_off-helper-in-kasan_init_sw_tags
+++ a/mm/kasan/sw_tags.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/stacktrace.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 #include <linux/types.h>
 #include <linux/vmalloc.h>
 #include <linux/bug.h>
@@ -45,7 +46,7 @@ void __init kasan_init_sw_tags(void)
 	kasan_init_tags();
 
 	pr_info("KernelAddressSanitizer initialized (sw-tags, stacktrace=%s)\n",
-		kasan_stack_collection_enabled() ? "on" : "off");
+		str_on_off(kasan_stack_collection_enabled()));
 }
 
 /*
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

kasan-hw_tags-use-str_on_off-helper-in-kasan_init_hw_tags.patch
mm-kfence-use-str_write_read-helper-in-get_access_type.patch
mm-damon-core-use-str_high_low-helper-in-damos_wmark_wait_us.patch
kasan-sw_tags-use-str_on_off-helper-in-kasan_init_sw_tags.patch

