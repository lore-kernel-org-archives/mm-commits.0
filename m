Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEE73C21
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0oFh4MjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869A3C433C9;
	Mon, 11 Dec 2023 00:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256070;
	bh=KCFWlTW1dlQR/e0LzINkmsJecJNbIef2HKjY15l/JFI=;
	h=Date:To:From:Subject:From;
	b=0oFh4MjKGPSowxiqRz1PleUM0AAq1CueRCj03Pkax2K2NSwmDdtV+KcLQ80T7/nUm
	 P8bgMyL9xbal3xhWnmapSBxvI2eibnpAa8eADbNWTHhycyMs5rFM93ORs4jKwp4TIR
	 teNKq68QjbxPQV4X9v2AjiGr+rFb9hVHk6yvo2/s=
Date: Sun, 10 Dec 2023 16:54:30 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,shikemeng@huaweicloud.com,quic_yingangl@quicinc.com,iamjoonsoo.kim@lge.com,audra@redhat.com,42.hyeyoo@gmail.com,21cnbao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-record-and-dump-free_pid-and-free_tgid.patch removed from -mm tree
Message-Id: <20231211005430.869A3C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: record and dump free_pid and free_tgid
has been removed from the -mm tree.  Its filename was
     mm-page_owner-record-and-dump-free_pid-and-free_tgid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <21cnbao@gmail.com>
Subject: mm/page_owner: record and dump free_pid and free_tgid
Date: Tue, 14 Nov 2023 16:42:02 +1300

While investigating some complex memory allocation and free bugs
especially in multi-processes and multi-threads cases, from time to time,
I feel the free stack isn't sufficient as a page can be freed by processes
or threads other than the one allocating it.  And other processes and
threads which free the page often have the exactly same free stack with
the one allocating the page.  We can't know who free the page only through
the free stack though the current page_owner does tell us the pid and tgid
of the one allocating the page.  This makes the bug investigation often
hard.

So this patch adds free pid and tgid in page_owner, so that we can easily
figure out if the freeing is crossing processes or threads.

Link: https://lkml.kernel.org/r/20231114034202.73098-1-v-songbaohua@oppo.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: Audra Mitchell <audra@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kassey Li <quic_yingangl@quicinc.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-record-and-dump-free_pid-and-free_tgid
+++ a/mm/page_owner.c
@@ -32,6 +32,8 @@ struct page_owner {
 	char comm[TASK_COMM_LEN];
 	pid_t pid;
 	pid_t tgid;
+	pid_t free_pid;
+	pid_t free_tgid;
 };
 
 static bool page_owner_enabled __initdata;
@@ -152,6 +154,8 @@ void __reset_page_owner(struct page *pag
 		page_owner = get_page_owner(page_ext);
 		page_owner->free_handle = handle;
 		page_owner->free_ts_nsec = free_ts_nsec;
+		page_owner->free_pid = current->pid;
+		page_owner->free_tgid = current->tgid;
 		page_ext = page_ext_next(page_ext);
 	}
 	page_ext_put(page_ext);
@@ -253,6 +257,8 @@ void __folio_copy_owner(struct folio *ne
 	new_page_owner->handle = old_page_owner->handle;
 	new_page_owner->pid = old_page_owner->pid;
 	new_page_owner->tgid = old_page_owner->tgid;
+	new_page_owner->free_pid = old_page_owner->free_pid;
+	new_page_owner->free_tgid = old_page_owner->free_tgid;
 	new_page_owner->ts_nsec = old_page_owner->ts_nsec;
 	new_page_owner->free_ts_nsec = old_page_owner->ts_nsec;
 	strcpy(new_page_owner->comm, old_page_owner->comm);
@@ -495,7 +501,8 @@ void __dump_page_owner(const struct page
 	if (!handle) {
 		pr_alert("page_owner free stack trace missing\n");
 	} else {
-		pr_alert("page last free stack trace:\n");
+		pr_alert("page last free pid %d tgid %d stack trace:\n",
+			  page_owner->free_pid, page_owner->free_tgid);
 		stack_depot_print(handle);
 	}
 
_

Patches currently in -mm which might be from 21cnbao@gmail.com are

mm-compaction-avoid-fast_isolate_freepages-blindly-choose-improper-pageblock.patch

