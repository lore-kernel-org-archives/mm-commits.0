Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8203B95F6
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294501; cv=none; b=pK453sxkZG+ZOPlaq2ttP5aZtks2yz8mO+plXMRW6tjZmfoQX4vcO/E8083i9uGXZdDmtbZCqG4zM7Qu6HqfIb5PgWry6SeczGemzDN1iOWwLlcIqMq7oXkxrs7teMzewVG6WlSnnXebf+grJeSMpTplHj8PYy4cE6i8ZbRmRHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294501; c=relaxed/simple;
	bh=t/f3x+PKAOt743/s8XrheXl7IyXSKLUgJtv5M4mJrZc=;
	h=Date:To:From:Subject:Message-Id; b=VdvsOnmaSsEsMppRBsXuqk6alSDJ7B+/+5z+pyf8FlU2Ns2gPVtEB1xkoPNwCHF4e1/sjUWdTL0KTQkbWuZ6VtFLJKm3hm6mtBUDEc65KraBe3T2iyll+QydH3W+IHLgb+Fot0ZdK4L1/5h824rIIiUllK+1XdSQb7T5kZv5Ywg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HwCn/den; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HwCn/den"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5403C19425;
	Mon, 27 Apr 2026 12:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294500;
	bh=t/f3x+PKAOt743/s8XrheXl7IyXSKLUgJtv5M4mJrZc=;
	h=Date:To:From:Subject:From;
	b=HwCn/denTKypEfG8esjrnfX/qvcyM3+sOApcO8Y5Y2BXvfH9KRD937EKKPe4OEFlK
	 Wd/jK0Hxm7PtjkofyYb3v/shz4cAwPSq3d33EMrJQIPbbtYwEHBBzgDeBTHBb2WNTO
	 xzXZrcC8ggFo8DyDQ+CoZaW3fYcX7GJHaze2WRbI=
Date: Mon, 27 Apr 2026 05:55:00 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] liveupdate-fix-return-value-on-session-allocation-failure.patch removed from -mm tree
Message-Id: <20260427125500.D5403C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: fix return value on session allocation failure
has been removed from the -mm tree.  Its filename was
     liveupdate-fix-return-value-on-session-allocation-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260415193738.515491-1-pasha.tatashin@soleen.com
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


