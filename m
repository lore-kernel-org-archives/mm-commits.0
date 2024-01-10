Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309AA6ABF
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ecTB9T7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A588C433F1;
	Wed, 10 Jan 2024 05:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704864600;
	bh=nSxN4hCaRoQus/MPDX9TreCSNoDYfM5u10+C37gCjuA=;
	h=Date:To:From:Subject:From;
	b=ecTB9T7z8Itr0RSpzpDvIJZM4JJZ7tcFtx64jEQfIW1r77AfeVKN7XDjnWKTDKZrD
	 uaMZL2q8x4FECLTmjhapXfmfYKY4iCe+S3DOGIlkzcgYw1A7YaIhIW+hF/mcuD51Es
	 6cT7/KnirSVdSoheE5zRF0oNgA9tD2/sbP220hy0=
Date: Tue, 09 Jan 2024 21:30:00 -0800
To: mm-commits@vger.kernel.org,tkjos@android.com,surenb@google.com,mingo@kernel.org,maco@android.com,kent.overstreet@gmail.com,keescook@chromium.org,joel@joelfernandes.org,jani.nikula@intel.com,gregkh@linuxfoundation.org,elver@google.com,colyli@suse.de,cmllamas@google.com,brauner@kernel.org,arve@android.com,andriy.shevchenko@linux.intel.com,pierre.gondois@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + binder-use-of-hlist_count_nodes.patch added to mm-nonmm-unstable branch
Message-Id: <20240110053000.9A588C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: binder: use of hlist_count_nodes()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     binder-use-of-hlist_count_nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/binder-use-of-hlist_count_nodes.patch

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
Subject: binder: use of hlist_count_nodes()
Date: Thu, 4 Jan 2024 17:49:34 +0100

Make use of the newly added hlist_count_nodes().

Link: https://lkml.kernel.org/r/20240104164937.424320-3-pierre.gondois@arm.com
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Coly Li <colyli@suse.de>
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

 drivers/android/binder.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/android/binder.c~binder-use-of-hlist_count_nodes
+++ a/drivers/android/binder.c
@@ -6077,9 +6077,7 @@ static void print_binder_node_nilocked(s
 	struct binder_work *w;
 	int count;
 
-	count = 0;
-	hlist_for_each_entry(ref, &node->refs, node_entry)
-		count++;
+	count = hlist_count_nodes(&node->refs);
 
 	seq_printf(m, "  node %d: u%016llx c%016llx hs %d hw %d ls %d lw %d is %d iw %d tr %d",
 		   node->debug_id, (u64)node->ptr, (u64)node->cookie,
_

Patches currently in -mm which might be from pierre.gondois@arm.com are

list-add-hlist_count_nodes.patch
binder-use-of-hlist_count_nodes.patch
bcache-use-of-hlist_count_nodes.patch

