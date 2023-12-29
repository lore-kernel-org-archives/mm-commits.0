Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3682713AE4
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CzMeRVji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033F3C433CA;
	Fri, 29 Dec 2023 20:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880081;
	bh=EITXH4B3F7VNLrGiVjviTWGKyVld5ZMHrFDoFcmtsXk=;
	h=Date:To:From:Subject:From;
	b=CzMeRVji2eQGVnxsDsy0LJERGLvliyVAlxUYwKC6t3J1vKWqdP8fKuiHWENd/9Zfs
	 4ELT51tClEH+5Jq/t9pQuKX31Jg35PmnYzP9g/OUQjstad4fHTiRann17AJRgkQ1qr
	 8qMe8STvDu+snHhIAK2VzueNRPOtmPsm3J054Htw=
Date: Fri, 29 Dec 2023 12:01:20 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,juntong.deng@outlook.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-reuse-kasan_track-in-kasan_stack_ring_entry.patch removed from -mm tree
Message-Id: <20231229200121.033F3C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: reuse kasan_track in kasan_stack_ring_entry
has been removed from the -mm tree.  Its filename was
     kasan-reuse-kasan_track-in-kasan_stack_ring_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: reuse kasan_track in kasan_stack_ring_entry
Date: Thu, 21 Dec 2023 19:35:38 +0100

Avoid duplicating fields of kasan_track in kasan_stack_ring_entry: reuse
the structure.

Link: https://lkml.kernel.org/r/20231221183540.168428-2-andrey.konovalov@linux.dev
Fixes: 5d4c6ac94694 ("kasan: record and report more information")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Juntong Deng <juntong.deng@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h       |    7 +------
 mm/kasan/report_tags.c |   12 ++++++------
 mm/kasan/tags.c        |   12 ++++++------
 3 files changed, 13 insertions(+), 18 deletions(-)

--- a/mm/kasan/kasan.h~kasan-reuse-kasan_track-in-kasan_stack_ring_entry
+++ a/mm/kasan/kasan.h
@@ -293,13 +293,8 @@ struct kasan_free_meta {
 struct kasan_stack_ring_entry {
 	void *ptr;
 	size_t size;
-	u32 pid;
-	depot_stack_handle_t stack;
+	struct kasan_track track;
 	bool is_free;
-#ifdef CONFIG_KASAN_EXTRA_INFO
-	u64 cpu:20;
-	u64 timestamp:44;
-#endif /* CONFIG_KASAN_EXTRA_INFO */
 };
 
 struct kasan_stack_ring {
--- a/mm/kasan/report_tags.c~kasan-reuse-kasan_track-in-kasan_stack_ring_entry
+++ a/mm/kasan/report_tags.c
@@ -31,8 +31,8 @@ static const char *get_common_bug_type(s
 static void kasan_complete_extra_report_info(struct kasan_track *track,
 					 struct kasan_stack_ring_entry *entry)
 {
-	track->cpu = entry->cpu;
-	track->timestamp = entry->timestamp;
+	track->cpu = entry->track.cpu;
+	track->timestamp = entry->track.timestamp;
 }
 #endif /* CONFIG_KASAN_EXTRA_INFO */
 
@@ -80,8 +80,8 @@ void kasan_complete_mode_report_info(str
 			if (free_found)
 				break;
 
-			info->free_track.pid = entry->pid;
-			info->free_track.stack = entry->stack;
+			info->free_track.pid = entry->track.pid;
+			info->free_track.stack = entry->track.stack;
 #ifdef CONFIG_KASAN_EXTRA_INFO
 			kasan_complete_extra_report_info(&info->free_track, entry);
 #endif /* CONFIG_KASAN_EXTRA_INFO */
@@ -98,8 +98,8 @@ void kasan_complete_mode_report_info(str
 			if (alloc_found)
 				break;
 
-			info->alloc_track.pid = entry->pid;
-			info->alloc_track.stack = entry->stack;
+			info->alloc_track.pid = entry->track.pid;
+			info->alloc_track.stack = entry->track.stack;
 #ifdef CONFIG_KASAN_EXTRA_INFO
 			kasan_complete_extra_report_info(&info->alloc_track, entry);
 #endif /* CONFIG_KASAN_EXTRA_INFO */
--- a/mm/kasan/tags.c~kasan-reuse-kasan_track-in-kasan_stack_ring_entry
+++ a/mm/kasan/tags.c
@@ -100,8 +100,8 @@ static void save_extra_info(struct kasan
 	u32 cpu = raw_smp_processor_id();
 	u64 ts_nsec = local_clock();
 
-	entry->cpu = cpu;
-	entry->timestamp = ts_nsec >> 3;
+	entry->track.cpu = cpu;
+	entry->track.timestamp = ts_nsec >> 3;
 }
 #endif /* CONFIG_KASAN_EXTRA_INFO */
 
@@ -134,15 +134,15 @@ next:
 	if (!try_cmpxchg(&entry->ptr, &old_ptr, STACK_RING_BUSY_PTR))
 		goto next; /* Busy slot. */
 
-	old_stack = entry->stack;
+	old_stack = entry->track.stack;
 
 	entry->size = cache->object_size;
-	entry->pid = current->pid;
-	entry->stack = stack;
-	entry->is_free = is_free;
+	entry->track.pid = current->pid;
+	entry->track.stack = stack;
 #ifdef CONFIG_KASAN_EXTRA_INFO
 	save_extra_info(entry);
 #endif /* CONFIG_KASAN_EXTRA_INFO */
+	entry->is_free = is_free;
 
 	entry->ptr = object;
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

