Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969741F94D
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 01:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352250; cv=none; b=HqZzC91VsgbG6upgOnv67tv1N+7ontCFJAc1R474OZFuI9AHilbrgY2jHg+sb1Xyb1luKsNh+ohgO2lFb1NeeOQS9RICF14INvMWS4JsxUryLAwigvwo+yFxkhLqEaEQuNBgBcWjsA4RpIFHV4XHDiysphhIOeOR1ffhi/LQcHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352250; c=relaxed/simple;
	bh=0LHTFFqIldDKytrxmEJST89UrZTcstgarCNbKhjWNs4=;
	h=Date:To:From:Subject:Message-Id; b=aYh/7INSdzw1HGwc+xuGW9SFViCUaaLh4nHKMRSEsRQBI2Tm4pFfr71sMy5V0J3TC3+jKCpM806JDXkMpqkq0O+Xn59ZFixH0yOQNHbZKPZgFIUvTKTH/9NN+GfHeldEdmPZkM1Jfx3ej1SNlDuUrpyOvo/WsH+eQlqCSfku0+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DPD5+qNh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DPD5+qNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59027C4CEC6;
	Tue,  8 Oct 2024 01:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728352250;
	bh=0LHTFFqIldDKytrxmEJST89UrZTcstgarCNbKhjWNs4=;
	h=Date:To:From:Subject:From;
	b=DPD5+qNhfbZ2ZcWfFfQ9iBvhcoWpbN/xABWY/u5DxyicdlPxfmL7gxSOkt7zrxK9r
	 DKj/xsYzrbnth3v9OJHdypXEOQLNvHJUPehnqLARuCcr5xrxCJ7SLCn5Qu3Tm05wMC
	 jRSy1qOG/3zJB5CDG/MepmLfNiGCeYb712mJQlRM=
Date: Mon, 07 Oct 2024 18:50:49 -0700
To: mm-commits@vger.kernel.org,lasse.collin@tukaani.org,t.v.s10123@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-possible-memory-leak-in-unxz.patch added to mm-nonmm-unstable branch
Message-Id: <20241008015050.59027C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/decompress_unxz.c: fix: possible memory leak in unxz()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fix-possible-memory-leak-in-unxz.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-possible-memory-leak-in-unxz.patch

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
From: Vishnu Sanal T <t.v.s10123@gmail.com>
Subject: lib/decompress_unxz.c: fix: possible memory leak in unxz()
Date: Sun, 6 Oct 2024 12:55:43 +0530

Fix possible memory leak in the function unxz() in lib/decompress_unxz.c
forgets to free the pointer 'in', when the statement if (fill == NULL &&
flush == NULL) is true.

Link: https://lkml.kernel.org/r/20241006072542.66442-2-t.v.s10123@gmail.com
Signed-off-by: Vishnu Sanal T <t.v.s10123@gmail.com>
Cc: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unxz.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/decompress_unxz.c~fix-possible-memory-leak-in-unxz
+++ a/lib/decompress_unxz.c
@@ -343,13 +343,13 @@ STATIC int INIT unxz(unsigned char *in,
 			}
 		} while (ret == XZ_OK);
 
-		if (must_free_in)
-			free(in);
-
 		if (flush != NULL)
 			free(b.out);
 	}
 
+	if (must_free_in)
+		free(in);
+
 	if (in_used != NULL)
 		*in_used += b.in_pos;
 
_

Patches currently in -mm which might be from t.v.s10123@gmail.com are

fix-possible-memory-leak-in-unxz.patch

