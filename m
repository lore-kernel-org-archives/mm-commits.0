Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F6BDDC4
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GMsJ6Uz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6148CC433F1;
	Wed, 10 Jan 2024 05:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704864602;
	bh=UzMmHW9WHBGxq9EVPgdEV7mj7GFO+QM+4b5N8As59j8=;
	h=Date:To:From:Subject:From;
	b=GMsJ6Uz5YZ1ggafffKjOXJmSTxktwYvfYgT/RNGcEe+CWKXRKyJBnorsSnwrCiEBc
	 +wfnyklKpYKGFedsei7w58qX6AnQ1jYrGmfq+tkDpkaTrc8ndFn8NiPN1lEfAjbe9Z
	 VmifPuGHoj6xF5LEkmoGE84vES5jns7pCa9ewklU=
Date: Tue, 09 Jan 2024 21:30:01 -0800
To: mm-commits@vger.kernel.org,tkjos@android.com,surenb@google.com,mingo@kernel.org,maco@android.com,kent.overstreet@gmail.com,keescook@chromium.org,joel@joelfernandes.org,jani.nikula@intel.com,gregkh@linuxfoundation.org,elver@google.com,colyli@suse.de,cmllamas@google.com,brauner@kernel.org,arve@android.com,andriy.shevchenko@linux.intel.com,pierre.gondois@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bcache-use-of-hlist_count_nodes.patch added to mm-nonmm-unstable branch
Message-Id: <20240110053002.6148CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bcache: use of hlist_count_nodes()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bcache-use-of-hlist_count_nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bcache-use-of-hlist_count_nodes.patch

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
Subject: bcache: use of hlist_count_nodes()
Date: Thu, 4 Jan 2024 17:49:35 +0100

Make use of the newly added hlist_count_nodes().

Link: https://lkml.kernel.org/r/20240104164937.424320-4-pierre.gondois@arm.com
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Acked-by: Coly Li <colyli@suse.de>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Llamas <cmllamas@google.com>
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

 drivers/md/bcache/sysfs.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/md/bcache/sysfs.c~bcache-use-of-hlist_count_nodes
+++ a/drivers/md/bcache/sysfs.c
@@ -702,13 +702,7 @@ static unsigned int bch_cache_max_chain(
 	for (h = c->bucket_hash;
 	     h < c->bucket_hash + (1 << BUCKET_HASH_BITS);
 	     h++) {
-		unsigned int i = 0;
-		struct hlist_node *p;
-
-		hlist_for_each(p, h)
-			i++;
-
-		ret = max(ret, i);
+		ret = max(ret, hlist_count_nodes(h));
 	}
 
 	mutex_unlock(&c->bucket_lock);
_

Patches currently in -mm which might be from pierre.gondois@arm.com are

list-add-hlist_count_nodes.patch
binder-use-of-hlist_count_nodes.patch
bcache-use-of-hlist_count_nodes.patch

