Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F89115D5A6
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663793; cv=none; b=Z3iZG/3EKGJNfzlLwZmjqUfwzEUqN5v6tET/+0sM3RF1aondn+5Obere/6GovdWRk05+YC6LTVHZKHWmGGNw90CSF+hHxAHkrJ+wHm03P4qG8lACza15LYHWnmeLHKRKmmtEP0zmmBCkBZ2k9pks5twSLwsNlSAzxviVpwoApj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663793; c=relaxed/simple;
	bh=4NlER2WVPQxfsBSYWAbaqCGVXk68Nuu4CUindzWEYPc=;
	h=Date:To:From:Subject:Message-Id; b=KNl07V8MSJgQt+CO9RTU0xH/ihbLYKzrZOYbC8NjoRXuUzar0JXuE+vRqUFBan2eAR3YHmQ+bv5Fp+XPKyiJU+DMCMWU6NIGbBKpBiZms0vPz4PTCigAFew2B0fiUsr4HIe8oAmzXyr7+JVoDSSS/v7btSNet4JuDx7TISJWaJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pcyWpFlS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pcyWpFlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0198DC113CC;
	Thu,  2 May 2024 15:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714663793;
	bh=4NlER2WVPQxfsBSYWAbaqCGVXk68Nuu4CUindzWEYPc=;
	h=Date:To:From:Subject:From;
	b=pcyWpFlS69gAblK6mY341qRgmjdF0HYcXt687fs0PC77EoYQztPukXDj+6mX8XaBc
	 2H4ny18sUcPcUYt59EwlXK+/Jc06Y3hBSazJVKYwj6OpsVKRzq563of6ENQp88TDl9
	 jPJfPNtOb6AvaV4bgzYuuynvlXgXHEUWrC4PH7z8=
Date: Thu, 02 May 2024 08:29:51 -0700
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch added to mm-unstable branch
Message-Id: <20240502152953.0198DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: send SIGBUS in the event of thp split fail
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

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
Subject: mm/memory-failure: send SIGBUS in the event of thp split fail
Date: Wed, 1 May 2024 17:24:58 -0600

When handle hwpoison in a GUP longterm pin'ed thp page,
try_to_split_thp_page() will fail.  And at this point, there is little
else the kernel could do except sending a SIGBUS to the user process, thus
give it a chance to recover.

Link: https://lkml.kernel.org/r/20240501232458.3919593-4-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail
+++ a/mm/memory-failure.c
@@ -2162,6 +2162,37 @@ out:
 	return rc;
 }
 
+/*
+ * The calling condition is as such: thp split failed, page might have
+ * been GUP longterm pinned, not much can be done for recovery.
+ * But a SIGBUS should be delivered with vaddr provided so that the user
+ * application has a chance to recover. Also, application processes'
+ * election for MCE early killed will be honored.
+ */
+static int kill_procs_now(struct page *p, unsigned long pfn, int flags,
+			struct page *hpage)
+{
+	struct folio *folio = page_folio(hpage);
+	LIST_HEAD(tokill);
+	int res = -EHWPOISON;
+
+	/* deal with user pages only */
+	if (PageReserved(p) || PageSlab(p) || PageTable(p) || PageOffline(p))
+		res = -EBUSY;
+	if (!(PageLRU(hpage) || PageHuge(p)))
+		res = -EBUSY;
+
+	if (res == -EHWPOISON) {
+		collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
+		kill_procs(&tokill, true, pfn, flags);
+	}
+
+	if (flags & MF_COUNT_INCREASED)
+		put_page(p);
+
+	return res;
+}
+
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -2291,6 +2322,11 @@ try_again:
 		 */
 		folio_set_has_hwpoisoned(folio);
 		if (try_to_split_thp_page(p) < 0) {
+			if (flags & MF_ACTION_REQUIRED) {
+				pr_err("%#lx: thp split failed\n", pfn);
+				res = kill_procs_now(p, pfn, flags, hpage);
+				goto unlock_mutex;
+			}
 			res = action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
 			goto unlock_mutex;
 		}
_

Patches currently in -mm which might be from jane.chu@oracle.com are

mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed.patch
mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

