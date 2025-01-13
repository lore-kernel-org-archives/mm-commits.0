Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072E425761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742238; cv=none; b=GDJxKamB65bHwpRaN3VFxeWOMpJZRieL7QjJYq/XeP3owK0K7KBLseoncBSKfePm/z2ILu4unxVLjsD3GQgArehBt6VpYs2hUWWqAYGL5J07eLD9I/rUyGDZdjCpex1AJ3hj9x/t7ZnSNkmP+SZ4zG8gIsw0QwJT4pke/ccgstA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742238; c=relaxed/simple;
	bh=8ceoW+nqB+/W+1rpREfhF+0HcZQLvKXcV7rCMnI1ne4=;
	h=Date:To:From:Subject:Message-Id; b=QZ+UKrFt8xNWbTnXnw3bxet+2B67oPbFdq91BCI/fsatbmeoBo7+InBjqaEi970qkRl/PbzkG96Lws9SxUnR9gRLJiHVhvyhwzQbZ9I3kb5HrT4SphM2UUU65uZpF/Z51QCTBZ95XidS514Yxgu7aL8vZU+hyfOBV7g1dsuY1/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JXZJBsmK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JXZJBsmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A9CC4CED6;
	Mon, 13 Jan 2025 04:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742237;
	bh=8ceoW+nqB+/W+1rpREfhF+0HcZQLvKXcV7rCMnI1ne4=;
	h=Date:To:From:Subject:From;
	b=JXZJBsmK9VP80RW5GGdi8U/Tmd8hX8wcdcX+LComosCFlRaONKx68RjBQf8QcdN6o
	 OAnWaWcKrpBnpnKSi7AsmTEWtVomcxg0dvVGb3kQBF4l7n6WTb4NlctwXudI4OjpFA
	 BR4cbiy5yZtQSOSiG+UBmd0FPDdxPQtNYhRllEyw=
Date: Sun, 12 Jan 2025 20:23:57 -0800
To: mm-commits@vger.kernel.org,vgupta@kernel.org,tursulin@ursulin.net,torvalds@linux-foundation.org,tglx@linutronix.de,simona@ffwll.ch,serge@hallyn.com,rodrigo.vivi@intel.com,pmladek@suse.com,peterz@infradead.org,paul@paul-moore.com,ogabbay@kernel.org,mingo@redhat.com,lyude@redhat.com,kvalo@kernel.org,kherbst@redhat.com,kees@kernel.org,joonas.lahtinen@linux.intel.com,johannes@sipsolutions.net,jmorris@namei.org,jirislaby@kernel.org,jani.nikula@linux.intel.com,hpa@zytor.com,gregkh@linuxfoundation.org,dvhart@infradead.org,dave@stgolabs.net,dave.hansen@linux.intel.com,dakr@redhat.com,bp@alien8.de,andriy.shevchenko@linux.intel.com,andrealmeid@igalia.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] net-remove-get_task_comm-and-print-task-comm-directly.patch removed from -mm tree
Message-Id: <20250113042357.C8A9CC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: net: remove get_task_comm() and print task comm directly
has been removed from the -mm tree.  Its filename was
     net-remove-get_task_comm-and-print-task-comm-directly.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: net: remove get_task_comm() and print task comm directly
Date: Thu, 19 Dec 2024 10:34:50 +0800

Since task->comm is guaranteed to be NUL-terminated, we can print it
directly without the need to copy it into a separate buffer.  This
simplifies the code and avoids unnecessary operations.

Link: https://lkml.kernel.org/r/20241219023452.69907-4-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "André Almeida" <andrealmeid@igalia.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Danilo Krummrich <dakr@redhat.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/wireless/wext-core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/wireless/wext-core.c~net-remove-get_task_comm-and-print-task-comm-directly
+++ a/net/wireless/wext-core.c
@@ -640,10 +640,8 @@ EXPORT_SYMBOL(wireless_send_event);
 #ifdef CONFIG_CFG80211_WEXT
 static void wireless_warn_cfg80211_wext(void)
 {
-	char name[sizeof(current->comm)];
-
 	pr_warn_once("warning: `%s' uses wireless extensions which will stop working for Wi-Fi 7 hardware; use nl80211\n",
-		     get_task_comm(name, current));
+		     current->comm);
 }
 #endif
 
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


