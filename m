Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1062917C79
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645172; cv=none; b=iDD/QHfgAl8qg3NvjLZRt9OQS3gNEeMr3Jk58tf45UUZMTQK++4aEOXqZJmjImrcl9qKSbtbo/D9PLjptP0rwVoLS0iG1flzTDvtbCHihC/qxTMlPfvvmahjzxuR5Cv6FoobkQQdvckVMJItllq1eNW/IJ/5Boe6lBb/4g6ccsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645172; c=relaxed/simple;
	bh=l6OdBlrtJhI5wSunFTYlRnt5ZPpTaId4+b3N8uf4iDo=;
	h=Date:To:From:Subject:Message-Id; b=oLm4ovWklXro1Gytx69go58Y5Xptrmy3vz/V09kiR2CkpLwOno4p/pRAfBpavzjznpktsqN8ds5CT7gddmnc4AmMDnJUg1kUPK5tLy+senRt3fi37LQ6f6CLXcpJVO7NgFjJE9uBVkqS3hmrK+h70jCJV/ce3SJ49IfTaYz9Hkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PkGPGbtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PkGPGbtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0A7C43390;
	Thu, 22 Feb 2024 23:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645171;
	bh=l6OdBlrtJhI5wSunFTYlRnt5ZPpTaId4+b3N8uf4iDo=;
	h=Date:To:From:Subject:From;
	b=PkGPGbtAMu0dMUTmemQz9z5EghGm0o7kcc2MRsCYTDgmPG6zA94ZpFDEaURZAAQVV
	 ZBu0k6hYW7m8NBk+bCVNc85khX8AYno3LtpGM4K26tNHi5NuYXSGObs71q3+PpDn+K
	 3L4c6kkBl4mk7/jfjkmgD+5IWzO43RuBOLUXPZxE=
Date: Thu, 22 Feb 2024 15:39:31 -0800
To: mm-commits@vger.kernel.org,tkjos@android.com,surenb@google.com,mingo@kernel.org,maco@android.com,kent.overstreet@gmail.com,keescook@chromium.org,joel@joelfernandes.org,jani.nikula@intel.com,gregkh@linuxfoundation.org,elver@google.com,colyli@suse.de,cmllamas@google.com,brauner@kernel.org,arve@android.com,andriy.shevchenko@linux.intel.com,pierre.gondois@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] bcache-use-of-hlist_count_nodes.patch removed from -mm tree
Message-Id: <20240222233931.8B0A7C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bcache: use of hlist_count_nodes()
has been removed from the -mm tree.  Its filename was
     bcache-use-of-hlist_count_nodes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


