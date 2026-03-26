Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C99EA92E
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 03:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774497257; cv=none; b=uf831TSWPLMYx6E/5i6vr/7qt4Bu86JZhbgrCUA7eKbQ4GqZkQZbITBpjVax3bAm6HTLH3HMV7xrhc8FXzSCBupU8RYnpDz2/5LYdvKatA4O1PCtr3JnRElKnIGB3tB6IZ5l0r6DV/uz02rvoUOj1GFWQ7th6GGMlyz8m0EbdAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774497257; c=relaxed/simple;
	bh=uIT8+bPuwgpM6uz4P73dxp9mXlyjzlGQGNKVBT7gPFs=;
	h=Date:To:From:Subject:Message-Id; b=pVrYipDqhopMTrxyuSkG/9vPyTBH+poVbz7ysJkxAAsbZjmwnM4KDuBKRtSHhTVwbCKixfeot4oH7rTzT1YFe1NwKTUXnPoQT9lMlded6dQEDRdOgFuTXUx4DWTlWhp5ls9sXdwIWZtroQsTpeE8AHn/J/Tzi+Jc5okWjygRTWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cVoT74ow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cVoT74ow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C648BC19424;
	Thu, 26 Mar 2026 03:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774497256;
	bh=uIT8+bPuwgpM6uz4P73dxp9mXlyjzlGQGNKVBT7gPFs=;
	h=Date:To:From:Subject:From;
	b=cVoT74ow+u/0X6iRwtiZNrhkN7IKwkMRf3fS2U84Cm+0gjW2Xb2pI/tL/BkDoHLpC
	 M2Rbyl0apaI6AMUqo20yNKvvRsjRN3SZEbYzib56vEsCVpWNw0hAZOxr3G9Hq0My9n
	 cwHt8u0QjYulDCv3UFznRbM78Bll4oZkJecNzjBY=
Date: Wed, 25 Mar 2026 20:54:16 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,leotimmins1974@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-propagate-file-deserialization-failures.patch added to mm-hotfixes-unstable branch
Message-Id: <20260326035416.C648BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: propagate file deserialization failures
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     liveupdate-propagate-file-deserialization-failures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-propagate-file-deserialization-failures.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Leo Timmins <leotimmins1974@gmail.com>
Subject: liveupdate: propagate file deserialization failures
Date: Wed, 25 Mar 2026 12:46:07 +0800

Patch series "liveupdate: fix incoming error handling and teardown paths",
v2.

This series fixes two issues in LUO's incoming-side error handling and
teardown paths.

The first patch makes session deserialization fail when file
deserialization fails, instead of silently continuing with a partially
restored session.

The second patch initializes incoming FLB state before the finish
pathdecrements its refcount, so the last-user cleanup path does not run
from an uninitialized count.  (and now utilises pr_warn instead of
WARN_ON).


This patch (of 2):

luo_session_deserialize() ignored the return value from
luo_file_deserialize().  As a result, a session could be left partially
restored even though the /dev/liveupdate open path treats deserialization
failures as fatal.

Propagate the error so a failed file deserialization aborts session
deserialization instead of silently continuing.

Link: https://lkml.kernel.org/r/20260325044608.8407-1-leotimmins1974@gmail.com
Link: https://lkml.kernel.org/r/20260325044608.8407-2-leotimmins1974@gmail.com
Fixes: 16cec0d26521 ("liveupdate: luo_session: add ioctls for file preservation")
Signed-off-by: Leo Timmins <leotimmins1974@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_session.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/liveupdate/luo_session.c~liveupdate-propagate-file-deserialization-failures
+++ a/kernel/liveupdate/luo_session.c
@@ -558,8 +558,13 @@ int luo_session_deserialize(void)
 		}
 
 		scoped_guard(mutex, &session->mutex) {
-			luo_file_deserialize(&session->file_set,
-					     &sh->ser[i].file_set_ser);
+			err = luo_file_deserialize(&session->file_set,
+						   &sh->ser[i].file_set_ser);
+		}
+		if (err) {
+			pr_warn("Failed to deserialize files for session [%s] %pe\n",
+				session->name, ERR_PTR(err));
+			return err;
 		}
 	}
 
_

Patches currently in -mm which might be from leotimmins1974@gmail.com are

liveupdate-propagate-file-deserialization-failures.patch
liveupdate-initialize-incoming-flb-state-before-finish.patch

