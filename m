Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116223793C5
	for <mm-commits@vger.kernel.org>; Thu, 16 Apr 2026 05:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776318837; cv=none; b=jjb8TqBBYzMz/TBRwCgjTTAHVHlMYevlplKUdNp24OM9rdsl1S86etb3gj8bgNBzKHA2jNEtpZKAyHqV/q+hmXuxcAiVSskwq5cnL8obs6ofy2EiMN0VwL1LC/ZF1Yappnx3W90v27HSKLW0wp/GrsvFuiIGHosMy2GM/7PMVOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776318837; c=relaxed/simple;
	bh=AChuDbF0S6xFWvZ7d9zfBzz0YWultwTNjwYtmu2n6Og=;
	h=Date:To:From:Subject:Message-Id; b=bHz6l3ZeoRi2kALc5N7iZpzELstmEn14vseah/DL5ah7BQBMpdlN1vb6Xuu5HxhHWPd5eKN4YZjjLkjN0rcA3duRkxgpDWN4PWXbOX2A36ydrjjUCbe691ooMP6TJupvjxAWK2syhCpMZytkp6V7Rn4/kN8pkoSQ6fiX6OPZHDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=weiisaz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="weiisaz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3E4C2BCB5;
	Thu, 16 Apr 2026 05:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776318836;
	bh=AChuDbF0S6xFWvZ7d9zfBzz0YWultwTNjwYtmu2n6Og=;
	h=Date:To:From:Subject:From;
	b=weiisaz86dsTjvAWlfGdJH5WGRFfkubRUYrQLo/KAffdQTTSVQQgtmO/RBMpqtWgd
	 /JWxbyaRP7eQxI62ANoKekiFKnyiFwtK8+JZN3SbZtfOtrCbuZgGL3XVSMUNoFjyjk
	 kOjadf33xX1r6hQOhgIqA+rJd69d6XJJ20U+tA2Y=
Date: Wed, 15 Apr 2026 22:53:52 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-fix-return-value-on-session-allocation-failure.patch added to mm-unstable branch
Message-Id: <20260416055355.EF3E4C2BCB5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: fix return value on session allocation failure
has been added to the -mm mm-unstable branch.  Its filename is
     liveupdate-fix-return-value-on-session-allocation-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-fix-return-value-on-session-allocation-failure.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: fix return value on session allocation failure
Date: Wed, 15 Apr 2026 19:37:38 +0000

When session allocation fails during deserialization, the global 'err'
variable was not updated before returning.  This caused subsequent calls
to luo_session_deserialize() to incorrectly report success.

Ensure 'err' is set to the error code from PTR_ERR(session).  This ensures
that an error is correctly returned to userspace when it attempts to open
/dev/liveupdate in the new kernel if deserialization failed.

Link: https://lkml.kernel.org/r/20260415193738.515491-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_session.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/kernel/liveupdate/luo_session.c~liveupdate-fix-return-value-on-session-allocation-failure
+++ a/kernel/liveupdate/luo_session.c
@@ -514,11 +514,12 @@ int luo_session_deserialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.incoming;
 	static bool is_deserialized;
-	static int err;
+	static int saved_err;
+	int err;
 
 	/* If has been deserialized, always return the same error code */
 	if (is_deserialized)
-		return err;
+		return saved_err;
 
 	is_deserialized = true;
 	if (!sh->active)
@@ -547,7 +548,8 @@ int luo_session_deserialize(void)
 			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
 				(int)sizeof(sh->ser[i].name),
 				sh->ser[i].name, session);
-			return PTR_ERR(session);
+			err = PTR_ERR(session);
+			goto save_err;
 		}
 
 		err = luo_session_insert(sh, session);
@@ -555,7 +557,7 @@ int luo_session_deserialize(void)
 			pr_warn("Failed to insert session [%s] %pe\n",
 				session->name, ERR_PTR(err));
 			luo_session_free(session);
-			return err;
+			goto save_err;
 		}
 
 		scoped_guard(mutex, &session->mutex) {
@@ -565,7 +567,7 @@ int luo_session_deserialize(void)
 		if (err) {
 			pr_warn("Failed to deserialize files for session [%s] %pe\n",
 				session->name, ERR_PTR(err));
-			return err;
+			goto save_err;
 		}
 	}
 
@@ -574,6 +576,9 @@ int luo_session_deserialize(void)
 	sh->ser = NULL;
 
 	return 0;
+save_err:
+	saved_err = err;
+	return err;
 }
 
 int luo_session_serialize(void)
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-prevent-double-management-of-files.patch
memfd-implement-get_id-for-memfd_luo.patch
selftests-liveupdate-add-test-for-double-preservation.patch
liveupdate-safely-print-untrusted-strings.patch
liveupdate-synchronize-lazy-initialization-of-flb-private-state.patch
liveupdate-protect-file-handler-list-with-rwsem.patch
liveupdate-protect-flb-lists-with-luo_register_rwlock.patch
liveupdate-defer-flb-module-refcounting-to-active-sessions.patch
liveupdate-remove-luo_session_quiesce.patch
liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch
liveupdate-remove-liveupdate_test_unregister.patch
liveupdate-make-unregister-functions-return-void.patch
liveupdate-defer-file-handler-module-refcounting-to-active-sessions.patch
maintainers-update-kexec-kdump-maintainers-entries.patch
liveupdate-fix-return-value-on-session-allocation-failure.patch

