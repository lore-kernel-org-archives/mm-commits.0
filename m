Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B3B14D719
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498815; cv=none; b=omKpJlXaDBtXk11zxcHWyR/BXe6M4HRmeqMh9AogxJ0Cxo9od60ZWSKj2gCNftB/fzFjlhoIr2+52yMRZifJPW9uI3U4JaSrP9wGLIjwn/pJGleuZV7njI982VlCqS9vI+zPtFBakPzkyTTNoDI56nn8kG+vU8qMCdJci4mz7BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498815; c=relaxed/simple;
	bh=jCym5faUcdzHfn5X9OMFcz+w0zEG6CnjxQNgO+Hkatg=;
	h=Date:To:From:Subject:Message-Id; b=Mev3/c38TMgZXDla25zcc47q/CymRoK0F76mBwM4k2+yyMUsxaKiNSuj3dHgPK1wouMhbarBQCMAQAnijJkkB3S6O7LykpFS9H1wetU5Fap+Cb54TXWdpBRS8ax239fmUOaFY6tJnucEjzZyAfa92qb7xIZ6KJH6AppDtCVXIyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=auoAajWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="auoAajWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCE2C19424;
	Sat, 18 Apr 2026 07:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498815;
	bh=jCym5faUcdzHfn5X9OMFcz+w0zEG6CnjxQNgO+Hkatg=;
	h=Date:To:From:Subject:From;
	b=auoAajWsoonlcEHFR2hF1TyXNo95qppQ0plqD9IdNkivr1VDYaZ68WXVO4HBXa9Mi
	 j187OsKwbE+ZWXkNf8ed0ZwS2EYy4BHxEL52lcFPKD8+L2FG+/eagMnNkKtXWUOdp2
	 D1i1jtYtLvi2UbkOzI6NHKnUiZAgPdbAZ8XehfLY=
Date: Sat, 18 Apr 2026 00:53:28 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] liveupdate-remove-liveupdate_test_unregister.patch removed from -mm tree
Message-Id: <20260418075334.4FCE2C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: remove liveupdate_test_unregister()
has been removed from the -mm tree.  Its filename was
     liveupdate-remove-liveupdate_test_unregister.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: remove liveupdate_test_unregister()
Date: Fri, 27 Mar 2026 03:33:32 +0000

Now that file handler unregistration automatically unregisters all
associated file handlers (FLBs), the liveupdate_test_unregister() function
is no longer needed.  Remove it along with its usages and declarations.

Link: https://lore.kernel.org/20260327033335.696621-9-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c     |    2 --
 kernel/liveupdate/luo_internal.h |    2 --
 lib/tests/liveupdate.c           |   18 ------------------
 3 files changed, 22 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-remove-liveupdate_test_unregister
+++ a/kernel/liveupdate/luo_file.c
@@ -926,8 +926,6 @@ int liveupdate_unregister_file_handler(s
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
-	liveupdate_test_unregister(fh);
-
 	guard(rwsem_write)(&luo_register_rwlock);
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
--- a/kernel/liveupdate/luo_internal.h~liveupdate-remove-liveupdate_test_unregister
+++ a/kernel/liveupdate/luo_internal.h
@@ -110,10 +110,8 @@ void luo_flb_serialize(void);
 
 #ifdef CONFIG_LIVEUPDATE_TEST
 void liveupdate_test_register(struct liveupdate_file_handler *fh);
-void liveupdate_test_unregister(struct liveupdate_file_handler *fh);
 #else
 static inline void liveupdate_test_register(struct liveupdate_file_handler *fh) { }
-static inline void liveupdate_test_unregister(struct liveupdate_file_handler *fh) { }
 #endif
 
 #endif /* _LINUX_LUO_INTERNAL_H */
--- a/lib/tests/liveupdate.c~liveupdate-remove-liveupdate_test_unregister
+++ a/lib/tests/liveupdate.c
@@ -135,24 +135,6 @@ void liveupdate_test_register(struct liv
 		TEST_NFLBS, fh->compatible);
 }
 
-void liveupdate_test_unregister(struct liveupdate_file_handler *fh)
-{
-	int err, i;
-
-	for (i = 0; i < TEST_NFLBS; i++) {
-		struct liveupdate_flb *flb = &test_flbs[i];
-
-		err = liveupdate_unregister_flb(fh, flb);
-		if (err) {
-			pr_err("Failed to unregister %s %pe\n",
-			       flb->compatible, ERR_PTR(err));
-		}
-	}
-
-	pr_info("Unregistered %d FLBs from file handler: [%s]\n",
-		TEST_NFLBS, fh->compatible);
-}
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pasha Tatashin <pasha.tatashin@soleen.com>");
 MODULE_DESCRIPTION("In-kernel test for LUO mechanism");
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-fix-return-value-on-session-allocation-failure.patch

