Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CA517C79
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645170; cv=none; b=GSCDOiybBY8jArfg/9jsnZ9vTVU+Mlh85yUyJ/GzF+J6o6mMC89pbVZff/8usYwoeEzsBd6j8fEnqcbNmZrxQwgkpCJv7sZWxilfEzofwukwnLOYHy4M3fQkdYT5fVavbM1pBUYHOLSTfpXQ+4bvAsC0SwhytB5cthYh2jR3yaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645170; c=relaxed/simple;
	bh=+lOxvprET0BiC/9XE7nPQUOlzix9kWiHYvNeYX5cIHM=;
	h=Date:To:From:Subject:Message-Id; b=lekcqlZxzXeoHK1vxIeP5EKLurKaiOcTsR50tw1hujZPtm1UuYWUGXvDfhrta3hHBbxPPr6Otu30+aY4Jnb+DygcCR4d6XQP9ja+UCKSCejqr3xSgbvJM+FIAwRmk9fIa1HTeMaYe2ulDDBcqC+BzQ0aeNelE5PQ+yNfRUbu9/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LORcUy0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LORcUy0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91F1C43390;
	Thu, 22 Feb 2024 23:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645169;
	bh=+lOxvprET0BiC/9XE7nPQUOlzix9kWiHYvNeYX5cIHM=;
	h=Date:To:From:Subject:From;
	b=LORcUy0t3qHJ7uLSQVTSfu2y/KLcIFMY5HWff/pI/OOQ+2jvKh2S8nqiQhD7ZH9vH
	 DcdV0/J3yw6IB3LGstlYiy0haaRjHFxkopeca+gmT1wrpZ5Zd40NWBXswiAwGAmKdw
	 RK+//AwPb+77V+Dgn29Kht8UnFbmQdobxgRU5nOw=
Date: Thu, 22 Feb 2024 15:39:29 -0800
To: mm-commits@vger.kernel.org,tkjos@android.com,surenb@google.com,mingo@kernel.org,maco@android.com,kent.overstreet@gmail.com,keescook@chromium.org,joel@joelfernandes.org,jani.nikula@intel.com,gregkh@linuxfoundation.org,elver@google.com,colyli@suse.de,cmllamas@google.com,brauner@kernel.org,arve@android.com,andriy.shevchenko@linux.intel.com,pierre.gondois@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] list-add-hlist_count_nodes.patch removed from -mm tree
Message-Id: <20240222233929.A91F1C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: list: add hlist_count_nodes()
has been removed from the -mm tree.  Its filename was
     list-add-hlist_count_nodes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pierre Gondois <pierre.gondois@arm.com>
Subject: list: add hlist_count_nodes()
Date: Thu, 4 Jan 2024 17:49:33 +0100

Add a generic hlist_count_nodes() function and use it in two drivers.


This patch (of 3):

Add a function to count nodes in a hlist.  hlist_count_nodes() is similar
to list_count_nodes().

Link: https://lkml.kernel.org/r/20240104164937.424320-1-pierre.gondois@arm.com
Link: https://lkml.kernel.org/r/20240104164937.424320-2-pierre.gondois@arm.com
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Acked-by: Coly Li <colyli@suse.de>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Martijn Coenen <maco@android.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/include/linux/list.h~list-add-hlist_count_nodes
+++ a/include/linux/list.h
@@ -1195,4 +1195,19 @@ static inline void hlist_splice_init(str
 	     pos && ({ n = pos->member.next; 1; });			\
 	     pos = hlist_entry_safe(n, typeof(*pos), member))
 
+/**
+ * hlist_count_nodes - count nodes in the hlist
+ * @head:	the head for your hlist.
+ */
+static inline size_t hlist_count_nodes(struct hlist_head *head)
+{
+	struct hlist_node *pos;
+	size_t count = 0;
+
+	hlist_for_each(pos, head)
+		count++;
+
+	return count;
+}
+
 #endif
_

Patches currently in -mm which might be from pierre.gondois@arm.com are


