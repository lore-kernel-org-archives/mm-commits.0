Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C8117B4E7
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 21:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716932665; cv=none; b=M3S2DSZ6vuPnI+rTq0+btB+Rc1MTynkiX6LxgfP5r9HROHwMFNp6Y7NsWuyNulcmADWBc4A8twC9uEBPYSbWognfp29R7Di9qqRfFYaX/HPp1wMkuBT4bbkjuKgVTBxWCQtRQsCY1O7mdJOaIyJWRbb278PK/tC3ZO74h0qrDic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716932665; c=relaxed/simple;
	bh=w6sngtb84sRWeZzGxfXZBxJNKHFgmQ69vsKRwAhIL2I=;
	h=Date:To:From:Subject:Message-Id; b=Oe1botO3fgNmEOIwdioUfBT0stcrsR/CLnL5ijjX1cPf4+nM+eExhh9cnSz12fzmZsH8kpTWdX4SP9gfy1KDNiFfUgNvt+0Wc568DbT3KGc6VXBYuwA3IyB4KI//3iVyv9tcyYzh2TRAv0rZWVBqqroXVCVl/B/0/5JIuKKxxhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F3aiUiiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F3aiUiiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0B4C3277B;
	Tue, 28 May 2024 21:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716932664;
	bh=w6sngtb84sRWeZzGxfXZBxJNKHFgmQ69vsKRwAhIL2I=;
	h=Date:To:From:Subject:From;
	b=F3aiUiiIK5s7RtUPWOPQ2f059wvGNCM84RawcvSNzCRxHiVHWu8e3vj+OXvDpHQoD
	 2JOHyCBQjoX00ZX97Wfw9zNE+0HfGCY1hCHYreEj3Zr//FZYtOah25WJJJE2JrEWeu
	 Vc5HsPBA3CP5lmr7qrBbHXC2xDl9FrU6tB0NCQ1c=
Date: Tue, 28 May 2024 14:44:24 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,oalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-improve-memory-failure-action_result-messages.patch added to mm-unstable branch
Message-Id: <20240528214424.BD0B4C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: improve memory failure action_result messages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-improve-memory-failure-action_result-messages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-improve-memory-failure-action_result-messages.patch

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
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: improve memory failure action_result messages
Date: Fri, 24 May 2024 15:53:04 -0600

Added two explicit MF_MSG messages describing failure in
get_hwpoison_page.  Attemped to document the definition of various action
names, and made a few adjustment to the action_result() calls.

Link: https://lkml.kernel.org/r/20240524215306.2705454-4-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <oalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    2 ++
 include/ras/ras_event.h |    2 ++
 mm/memory-failure.c     |   37 ++++++++++++++++++++++++++++++++-----
 3 files changed, 36 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-memory-failure-improve-memory-failure-action_result-messages
+++ a/include/linux/mm.h
@@ -4103,6 +4103,7 @@ enum mf_action_page_type {
 	MF_MSG_DIFFERENT_COMPOUND,
 	MF_MSG_HUGE,
 	MF_MSG_FREE_HUGE,
+	MF_MSG_GET_HWPOISON,
 	MF_MSG_UNMAP_FAILED,
 	MF_MSG_DIRTY_SWAPCACHE,
 	MF_MSG_CLEAN_SWAPCACHE,
@@ -4116,6 +4117,7 @@ enum mf_action_page_type {
 	MF_MSG_BUDDY,
 	MF_MSG_DAX,
 	MF_MSG_UNSPLIT_THP,
+	MF_MSG_ALREADY_POISONED,
 	MF_MSG_UNKNOWN,
 };
 
--- a/include/ras/ras_event.h~mm-memory-failure-improve-memory-failure-action_result-messages
+++ a/include/ras/ras_event.h
@@ -360,6 +360,7 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_DIFFERENT_COMPOUND, "different compound page after locking" ) \
 	EM ( MF_MSG_HUGE, "huge page" )					\
 	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
+	EM ( MF_MSG_GET_HWPOISON, "get hwpoison page" )			\
 	EM ( MF_MSG_UNMAP_FAILED, "unmapping failed page" )		\
 	EM ( MF_MSG_DIRTY_SWAPCACHE, "dirty swapcache page" )		\
 	EM ( MF_MSG_CLEAN_SWAPCACHE, "clean swapcache page" )		\
@@ -373,6 +374,7 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_BUDDY, "free buddy page" )				\
 	EM ( MF_MSG_DAX, "dax page" )					\
 	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
+	EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )		\
 	EMe ( MF_MSG_UNKNOWN, "unknown page" )
 
 /*
--- a/mm/memory-failure.c~mm-memory-failure-improve-memory-failure-action_result-messages
+++ a/mm/memory-failure.c
@@ -879,6 +879,28 @@ static int kill_accessing_process(struct
 	return ret > 0 ? -EHWPOISON : -EFAULT;
 }
 
+/*
+ * MF_IGNORED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * But it could not do more to isolate the page from being accessed again,
+ * nor does it kill the process. This is extremely rare and one of the
+ * potential causes is that the page state has been changed due to
+ * underlying race condition. This is the most severe outcomes.
+ *
+ * MF_FAILED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * It should have killed the process, but it can't isolate the page,
+ * due to conditions such as extra pin, unmap failure, etc. Accessing
+ * the page again may trigger another MCE and the process will be killed
+ * by the m-f() handler immediately.
+ *
+ * MF_DELAYED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * The page is unmapped, and is removed from the LRU or file mapping.
+ * An attempt to access the page again will trigger page fault and the
+ * PF handler will kill the process.
+ *
+ * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * The page has been completely isolated, that is, unmapped, taken out of
+ * the buddy system, or hole-punnched out of the file mapping.
+ */
 static const char *action_name[] = {
 	[MF_IGNORED] = "Ignored",
 	[MF_FAILED] = "Failed",
@@ -893,6 +915,7 @@ static const char * const action_page_ty
 	[MF_MSG_DIFFERENT_COMPOUND]	= "different compound page after locking",
 	[MF_MSG_HUGE]			= "huge page",
 	[MF_MSG_FREE_HUGE]		= "free huge page",
+	[MF_MSG_GET_HWPOISON]		= "get hwpoison page",
 	[MF_MSG_UNMAP_FAILED]		= "unmapping failed page",
 	[MF_MSG_DIRTY_SWAPCACHE]	= "dirty swapcache page",
 	[MF_MSG_CLEAN_SWAPCACHE]	= "clean swapcache page",
@@ -906,6 +929,7 @@ static const char * const action_page_ty
 	[MF_MSG_BUDDY]			= "free buddy page",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
+	[MF_MSG_ALREADY_POISONED]	= "already poisoned",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1013,12 +1037,13 @@ static int me_kernel(struct page_state *
 
 /*
  * Page in unknown state. Do nothing.
+ * This is a catch-all in case we fail to make sense of the page state.
  */
 static int me_unknown(struct page_state *ps, struct page *p)
 {
 	pr_err("%#lx: Unknown page state\n", page_to_pfn(p));
 	unlock_page(p);
-	return MF_FAILED;
+	return MF_IGNORED;
 }
 
 /*
@@ -2055,6 +2080,7 @@ retry:
 		if (flags & MF_ACTION_REQUIRED) {
 			folio = page_folio(p);
 			res = kill_accessing_process(current, folio_pfn(folio), flags);
+			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		}
 		return res;
 	} else if (res == -EBUSY) {
@@ -2062,7 +2088,7 @@ retry:
 			flags |= MF_NO_RETRY;
 			goto retry;
 		}
-		return action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
+		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
 	}
 
 	folio = page_folio(p);
@@ -2097,7 +2123,7 @@ retry:
 
 	if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
 		folio_unlock(folio);
-		return action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
+		return action_result(pfn, MF_MSG_UNMAP_FAILED, MF_FAILED);
 	}
 
 	return identify_page_state(pfn, p, page_flags);
@@ -2231,6 +2257,7 @@ try_again:
 			res = kill_accessing_process(current, pfn, flags);
 		if (flags & MF_COUNT_INCREASED)
 			put_page(p);
+		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		goto unlock_mutex;
 	}
 
@@ -2267,7 +2294,7 @@ try_again:
 			}
 			goto unlock_mutex;
 		} else if (res < 0) {
-			res = action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
+			res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
 			goto unlock_mutex;
 		}
 	}
@@ -2363,7 +2390,7 @@ try_again:
 	 * Abort on fail: __filemap_remove_folio() assumes unmapped page.
 	 */
 	if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
-		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
+		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_FAILED);
 		goto unlock_page;
 	}
 
_

Patches currently in -mm which might be from jane.chu@oracle.com are

mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed.patch
mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch
mm-memory-failure-improve-memory-failure-action_result-messages.patch
mm-memory-failure-move-hwpoison_filter-higher-up.patch
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

