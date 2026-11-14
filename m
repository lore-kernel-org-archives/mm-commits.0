Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794628245;
	b=z7L28HWRV2yk27WPds3soVpQtPBtgPRgA+LqIXH/ZUQ+2mJADyb6LpHDVgF8vumDG2cJ
	 /Fg+UR/Ep8X7IcLVqtK+4pZk3NLusM4T0GgZ67AWb/rPfZLSEFG3kAXg/8diKS6V1oK7K
	 /FgSybcXibDsiYT4IXGAD5KgtyPLiapUcaLRoNFnY7qEcroC8TCqyN8aXHUonISfvUvnh
	 n1LadQpFK2QO1awEPLv/SCuIVPG2sP3DjTVX6gKpvB/FUBnoY2qp2cxuXxTm6cRi52u49
	 xRpMhVBKeADLNhKwyIy3sG4POyhoEuUZgE92BHpAXVAEYissg2pPkzjpDYwTvQaS0dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794628245;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=W/V4B/pGTOV/0dkaKeuQqPlifq3O6UcnPeHSuJgQHQA=;
	b=gb50hPkATFRYC8zyhaYNJsyF97FKabUabyKDfbuSckxO0QlSM7DxWT6KgLM3OmHnJrT5
	 o/5TinBrKQZi0k2V/HiTI/skacYnxywJ/CuprubO9Gmc9nGbjIkY7vOksUrv0nnTD9w6I
	 7Qp+2BdC+NGGxvgYK4CcAo5pZ6oHgn0Du/xH1MxYhYHiVKXJyBD1+BJTfhG+iXpfZ7iJX
	 8m1rSrXt7NIDCKTsrvOYU0yZKo/QXIfF/SSdakiYFK9Q3vcea47zsuMLEDyD82Nm5atp4
	 elafjuDavMUS/A+3WvgRHja4TzU2iUELiQj+j54pUcu9/S4/TNjfI+835AXNU4S9D8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="rqarS/V6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5751606A330
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 03:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rqarS/V6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B431F000C4;
	Sat, 14 Nov 2026 03:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794628245;
	bh=W/V4B/pGTOV/0dkaKeuQqPlifq3O6UcnPeHSuJgQHQA=;
	h=Date:To:From:Subject;
	b=rqarS/V6ke2Q/VjcdgJnDPGW23rKs09LpJgn27/tr+GuXXB4HZmQDEiB+Vs4VI8QQ
	 XGrzOu5Iyju/gFztkpl8h8vHDphzshzlD4K+Y97lGHIj/MGvhTdm/2ZTZibUAGP9CX
	 DW/oRyCfETm1Y4bj6V/geghWLegmKiejo+Y/oZVQ=
Date: Fri, 13 Nov 2026 19:50:45 -0800
To: mm-commits@vger.kernel.org,wy@wyuan.org,users@kernel.org,
	skhan@linuxfoundation.org,si.yanteng@linux.dev,rdunlap@infradead.org,
	petr.pavlu@suse.com,joe@perches.com,federico.vaga@vaga.pv.it,
	dzm91@hust.edu.cn,corbet@lwn.net,chenyou910331@gmail.com,
	carlos.bilbao@kernel.org,avadhut.naik@amd.com,alexs@kernel.org,
	akiyks@gmail.com,konstantin@linuxfoundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-submitting-patches-make-lkml-a-list-of-last-resort-again.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261114035045.76B431F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: docs: submitting-patches: make LKML a list of last resort again
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     docs-submitting-patches-make-lkml-a-list-of-last-resort-again.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-submitting-patches-make-lkml-a-list-of-last-resort-again.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
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
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: docs: submitting-patches: make LKML a list of last resort again
Date: Fri, 13 Nov 2026 18:02:46 -0500

Commit 77167b966b7e ("docs: submitting-patches: clarify the role of LKML")
changed the documentation to say that all patches should be sent to LKML
by default, because get_maintainer.pl always suggested it.

Now that get_maintainer.pl only falls back to THE REST when no other
matching section provides a mailing list, update the documentation to
match: send patches to the subsystem-specific list, and use LKML only when
there isn't one.

Link: https://lore.kernel.org/20261113-get-maintainer-the-rest-fallback-v3-2-36ee5a3e8d13@linuxfoundation.org
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Federico Vaga <federico.vaga@vaga.pv.it>
Cc: Akira Yokosawa <akiyks@gmail.com>
Cc: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Avadhut Naik <avadhut.naik@amd.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Chen-Yu Yeh <chenyou910331@gmail.com>
Cc: Weijie Yuan <wy@wyuan.org>
Cc: <users@kernel.org>

 Documentation/process/submitting-patches.rst |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/Documentation/process/submitting-patches.rst~docs-submitting-patches-make-lkml-a-list-of-last-resort-again
+++ a/Documentation/process/submitting-patches.rst
@@ -239,9 +239,12 @@ patches as arguments to scripts/get_main
 maintainer for the subsystem you are working on, Andrew Morton
 (akpm@linux-foundation.org) serves as a maintainer of last resort.
 
-linux-kernel@vger.kernel.org should be used by default for all patches, but the
-volume on that list has caused a number of developers to tune it out.  Please
-do not spam unrelated lists and unrelated people, though.
+You should also normally choose at least one mailing list to receive a copy of
+your patch set.  Look in the MAINTAINERS file for a subsystem-specific list;
+your patch will probably get more attention there.
+linux-kernel@vger.kernel.org functions as a list of last resort for patches
+that do not have a subsystem-specific list.  Please do not spam unrelated lists
+and unrelated people, though.
 
 Many kernel-related lists are hosted at kernel.org; you can find a list
 of them at https://subspace.kernel.org.  There are kernel-related lists
_

Patches currently in -mm which might be from konstantin@linuxfoundation.org are

get_maintainer-only-use-the-rest-as-a-fallback.patch
docs-submitting-patches-make-lkml-a-list-of-last-resort-again.patch

