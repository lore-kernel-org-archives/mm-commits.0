Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663C16ABF
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rt/PjNQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2162C433C7;
	Wed, 10 Jan 2024 05:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704864598;
	bh=hzMwayT52uhdXa6fOySr+j68Xhr2VZxxv3aceUUB70Y=;
	h=Date:To:From:Subject:From;
	b=rt/PjNQg3HRXEmKj1buDALVNCCSVykMME8+in8LKyeRasfTvpL3DtqMT2fsODx0mR
	 PjzStGXWbQgjqW/EfiFxsO2kyVQPkSzpHDVyffk/AUMAYm1WTB+N3ZVbWjekZiBIiC
	 ly8xmxy6fPIFGqM056FM8wVQu14O6JQxiKCb1oGs=
Date: Tue, 09 Jan 2024 21:29:58 -0800
To: mm-commits@vger.kernel.org,tkjos@android.com,surenb@google.com,mingo@kernel.org,maco@android.com,kent.overstreet@gmail.com,keescook@chromium.org,joel@joelfernandes.org,jani.nikula@intel.com,gregkh@linuxfoundation.org,elver@google.com,colyli@suse.de,cmllamas@google.com,brauner@kernel.org,arve@android.com,andriy.shevchenko@linux.intel.com,pierre.gondois@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + list-add-hlist_count_nodes.patch added to mm-nonmm-unstable branch
Message-Id: <20240110052958.C2162C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: list: add hlist_count_nodes()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     list-add-hlist_count_nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/list-add-hlist_count_nodes.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
@@ -1175,4 +1175,19 @@ static inline void hlist_move_list(struc
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

list-add-hlist_count_nodes.patch
binder-use-of-hlist_count_nodes.patch
bcache-use-of-hlist_count_nodes.patch

