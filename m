Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565AEEAC5
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337164; cv=none; b=ODzcmDHqES60Cz3hgvHLvDcsHkTzF9a/Rx19Hac3lGFnNj+5TeUW9xuRp/ZAtKWldojKknxepMeWGXddlNI9Xbc3fWNIQkrx8aghBrpGQyKXj3fIbdi6axlHdgTrjB43kXiYamfIUb0Wto7s4hYyL+Y9bDJr541u1hbnwJnBGHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337164; c=relaxed/simple;
	bh=qOIfiX/I7S3ObWd7Lwqm5gjaWZyKixPvxwQIB0qVR+s=;
	h=Date:To:From:Subject:Message-Id; b=dL8ympEkBaVTQNmy6gPbjCAMRCZOWYrAgs3Us+Nycs8kO+VPY88bmvIS7OxnszUWHq5cIrXj9Svu2JgUsJFqelcXG4EwXL96IhpzVEj/1cIOl0g+j2ZHSNlfSdLXs+bGenrbOl+Q3QchXG7OBIc6acpJCxvpzXWQ5Jrf8PwwLk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qgxaOEkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qgxaOEkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B30EC4CED6;
	Mon, 20 Jan 2025 01:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337164;
	bh=qOIfiX/I7S3ObWd7Lwqm5gjaWZyKixPvxwQIB0qVR+s=;
	h=Date:To:From:Subject:From;
	b=qgxaOEkc7+O2h96vSHZ9qd+QaRct9yn0HrTKXv0AzfIPd+BvU7r9JQLSsmKnNDt3r
	 N4z1sXxtBGTgFrmyTV/T0IBULMOvaJpIbZ+2CuZdvQ0PNRdd0AmnpWlrJwsPO72RIv
	 QKLwNjGHPeosxJMbPvDZmLwKIWUYuTP7tFmG/BKo=
Date: Sun, 19 Jan 2025 17:39:23 -0800
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,anshuman.khandual@arm.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kfence-use-str_write_read-helper-in-get_access_type.patch removed from -mm tree
Message-Id: <20250120013924.2B30EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kfence: use str_write_read() helper in get_access_type()
has been removed from the -mm tree.  Its filename was
     mm-kfence-use-str_write_read-helper-in-get_access_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

ocfs2-use-str_yes_no-and-str_no_yes-helper-functions.patch

