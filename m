Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B67A13AF1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FUlxipUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079E6C433CA;
	Fri, 29 Dec 2023 20:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880083;
	bh=3Grm8uett7xx11s/EQ7abQEjlhktjQYJcN+Izj8fVD4=;
	h=Date:To:From:Subject:From;
	b=FUlxipUqUAaCUEWP2X6VfnJMLYKUp5oNuO7qibSSajbpOyJ5eCWfSZWcHV0zNCoRt
	 FlQ6Y4Lbx3Q6k3N6sTmdth1m4YSiZ5zT2HDvkFIX+KZszm6l4TzhAq5Umcp9Wm6Q4G
	 UXDpBSMVSDhd+xrEtYajrdxr56LBF1ZfR7koGxjE=
Date: Fri, 29 Dec 2023 12:01:22 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,juntong.deng@outlook.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-simplify-kasan_complete_mode_report_info-for-tag-based-modes.patch removed from -mm tree
Message-Id: <20231229200123.079E6C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: simplify kasan_complete_mode_report_info for tag-based modes
has been removed from the -mm tree.  Its filename was
     kasan-simplify-kasan_complete_mode_report_info-for-tag-based-modes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: simplify kasan_complete_mode_report_info for tag-based modes
Date: Thu, 21 Dec 2023 19:35:40 +0100

memcpy the alloc/free tracks when collecting the information about a bad
access instead of copying fields one by one.

Link: https://lkml.kernel.org/r/20231221183540.168428-4-andrey.konovalov@linux.dev
Fixes: 5d4c6ac94694 ("kasan: record and report more information")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Juntong Deng <juntong.deng@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report_tags.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

--- a/mm/kasan/report_tags.c~kasan-simplify-kasan_complete_mode_report_info-for-tag-based-modes
+++ a/mm/kasan/report_tags.c
@@ -27,15 +27,6 @@ static const char *get_common_bug_type(s
 	return "invalid-access";
 }
 
-#ifdef CONFIG_KASAN_EXTRA_INFO
-static void kasan_complete_extra_report_info(struct kasan_track *track,
-					 struct kasan_stack_ring_entry *entry)
-{
-	track->cpu = entry->track.cpu;
-	track->timestamp = entry->track.timestamp;
-}
-#endif /* CONFIG_KASAN_EXTRA_INFO */
-
 void kasan_complete_mode_report_info(struct kasan_report_info *info)
 {
 	unsigned long flags;
@@ -80,11 +71,8 @@ void kasan_complete_mode_report_info(str
 			if (free_found)
 				break;
 
-			info->free_track.pid = entry->track.pid;
-			info->free_track.stack = entry->track.stack;
-#ifdef CONFIG_KASAN_EXTRA_INFO
-			kasan_complete_extra_report_info(&info->free_track, entry);
-#endif /* CONFIG_KASAN_EXTRA_INFO */
+			memcpy(&info->free_track, &entry->track,
+			       sizeof(info->free_track));
 			free_found = true;
 
 			/*
@@ -98,11 +86,8 @@ void kasan_complete_mode_report_info(str
 			if (alloc_found)
 				break;
 
-			info->alloc_track.pid = entry->track.pid;
-			info->alloc_track.stack = entry->track.stack;
-#ifdef CONFIG_KASAN_EXTRA_INFO
-			kasan_complete_extra_report_info(&info->alloc_track, entry);
-#endif /* CONFIG_KASAN_EXTRA_INFO */
+			memcpy(&info->alloc_track, &entry->track,
+			       sizeof(info->alloc_track));
 			alloc_found = true;
 
 			/*
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

