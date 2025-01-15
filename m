Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4702A14A60C
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 22:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736981827; cv=none; b=YRPASMoCl6gNtWirihja9LXZ4HDtlpzPG3+e6anf4WUX5tKD3eT1asiY/EqQb+iGH+nVh4lAg2tV9p23B9ti1ffumqlW0aYwPxInFIgfWTpMDAwehW0zELJAcQpcE9oAH+QdeSv7RdZdSYEE+/g+6cxSBxfisIlP91iCxDz39+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736981827; c=relaxed/simple;
	bh=08bWmsvJbceQP5K+z/tyv9/+bidiHkmobKgB7C7M6hs=;
	h=Date:To:From:Subject:Message-Id; b=NHUXn5WZ2rbDAGYhIHCn/1eGEd8gVKNMZii81v5ZFla5P0Xh6z3mmFESdaiLVPz2Ya7MnvPW4TBOoMkpffflZzdI8ldhpdTT4RC8Gyte9V4V0irNrV3ZQE9Yr6zHuvuihRHVsmiWI8fSHobgdpNct35P4eUWgzqxMaDm/pw0HNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FU36ibf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FU36ibf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE16EC4CED1;
	Wed, 15 Jan 2025 22:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736981826;
	bh=08bWmsvJbceQP5K+z/tyv9/+bidiHkmobKgB7C7M6hs=;
	h=Date:To:From:Subject:From;
	b=FU36ibf3Jgc4hEoqWvxsaqX0LJAv3sTnE8cW46ggBfVyORglZagsHVYk4XNQQt1se
	 Qo8EsNqfugRfD2ov6sUjixi3W5rhiFuUNpG90eMwcQiw1olJ9xcLvOeqZSkKxr5ZJZ
	 3uStwkuzmke9iC2IVI3TaD6UTlRYbWAGiH0HYKHo=
Date: Wed, 15 Jan 2025 14:57:06 -0800
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,anshuman.khandual@arm.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-use-str_write_read-helper-in-get_access_type.patch added to mm-unstable branch
Message-Id: <20250115225706.AE16EC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kfence: use str_write_read() helper in get_access_type()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kfence-use-str_write_read-helper-in-get_access_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-use-str_write_read-helper-in-get_access_type.patch

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
Subject: mm/kfence: use str_write_read() helper in get_access_type()
Date: Wed, 15 Jan 2025 16:55:12 +0100

Remove hard-coded strings by using the str_write_read() helper function.

Link: https://lkml.kernel.org/r/20250115155511.954535-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |    3 ++-
 mm/kfence/report.c      |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/mm/kfence/kfence_test.c~mm-kfence-use-str_write_read-helper-in-get_access_type
+++ a/mm/kfence/kfence_test.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 #include <linux/tracepoint.h>
 #include <trace/events/printk.h>
 
@@ -88,7 +89,7 @@ struct expect_report {
 
 static const char *get_access_type(const struct expect_report *r)
 {
-	return r->is_write ? "write" : "read";
+	return str_write_read(r->is_write);
 }
 
 /* Check observed report matches information in @r. */
--- a/mm/kfence/report.c~mm-kfence-use-str_write_read-helper-in-get_access_type
+++ a/mm/kfence/report.c
@@ -16,6 +16,7 @@
 #include <linux/sprintf.h>
 #include <linux/stacktrace.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 #include <linux/sched/clock.h>
 #include <trace/events/error_report.h>
 
@@ -184,7 +185,7 @@ static void print_diff_canary(unsigned l
 
 static const char *get_access_type(bool is_write)
 {
-	return is_write ? "write" : "read";
+	return str_write_read(is_write);
 }
 
 void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *regs,
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

kasan-hw_tags-use-str_on_off-helper-in-kasan_init_hw_tags.patch
mm-kfence-use-str_write_read-helper-in-get_access_type.patch

