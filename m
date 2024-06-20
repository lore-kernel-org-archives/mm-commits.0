Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D08419B
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718845776; cv=none; b=j4TsvtP0sLjctpv0MkMqbIKLh9I7vILDTal8DGnh1RVlW+nI/fIEygcjr4Tv3QBF46gb5JX0EvTrZ8PLJM3zLTSGrwQZreeyS0G0B0H2w1WKxo8HFdbw9GCDidOY5/L4GyNIAOkQlML+0gE7OaDF6SoFFGyXvIYFGZ+c+zd0RHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718845776; c=relaxed/simple;
	bh=CtO0ira3uMgfeURfxJiRPTaB/fdVyui7gigqTE8WUKA=;
	h=Date:To:From:Subject:Message-Id; b=PWw5Nr7vwfZiBUzXPRskB+TIET1/ZXXH0yzsiVfoCdFp7c4PFgTPDnFaNb0TFt09Lh99tQL6bsTrufLMAFS9Erw+/kL6CbUOBvqlTnifDobJSy4KGN6ZMVmV1o4QuwlKOnq+htTGiPO7efk6Ansle3fBrMczD6Z8kq7nPPealXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fN5aAlWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fN5aAlWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D83C2BBFC;
	Thu, 20 Jun 2024 01:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718845776;
	bh=CtO0ira3uMgfeURfxJiRPTaB/fdVyui7gigqTE8WUKA=;
	h=Date:To:From:Subject:From;
	b=fN5aAlWma7HvpnY3HBc4iqH31o6T7n8PeKWx8Gp6RNPkDpeIXmM+khZXsI8Emcol3
	 miZ0HJPmvX/DkjXuh6DY82DSJaWKXouRiM7mKlDBAeS7IbnYpyJC6e7zCY0CW9Pe1M
	 CB213lIqFL7Q6NToiCWMrwHI7O4yFlmRzY+20zlg=
Date: Wed, 19 Jun 2024 18:09:35 -0700
To: mm-commits@vger.kernel.org,mripard@kernel.org,bmasney@redhat.com,javierm@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kconfig-mention-arm64-in-default_mmap_min_addr-symbol-help-text.patch added to mm-unstable branch
Message-Id: <20240620010935.E0D83C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/Kconfig: mention arm64 in DEFAULT_MMAP_MIN_ADDR symbol help text
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kconfig-mention-arm64-in-default_mmap_min_addr-symbol-help-text.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kconfig-mention-arm64-in-default_mmap_min_addr-symbol-help-text.patch

This patch will later appear in the mm-unstable branch at
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
From: Javier Martinez Canillas <javierm@redhat.com>
Subject: mm/Kconfig: mention arm64 in DEFAULT_MMAP_MIN_ADDR symbol help text
Date: Wed, 19 Jun 2024 10:30:38 +0200

Currently ppc64 and x86 are mentioned as architectures where a 65536 value
is reasonable but arm64 isn't listed and it is also a 64-bit architecture.

The help text says that for "arm" the value should be no higher than 32768
but it's only talking about 32-bit ARM.  Adding arm64 to the above list
can make this more clear and avoid confusing users who may think that the
32k limit would also apply to 64-bit ARM.

Link: https://lkml.kernel.org/r/20240619083047.114613-1-javierm@redhat.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Cc: Brian Masney <bmasney@redhat.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-kconfig-mention-arm64-in-default_mmap_min_addr-symbol-help-text
+++ a/mm/Kconfig
@@ -714,7 +714,7 @@ config DEFAULT_MMAP_MIN_ADDR
 	  from userspace allocation.  Keeping a user from writing to low pages
 	  can help reduce the impact of kernel NULL pointer bugs.
 
-	  For most ppc64 and x86 users with lots of address space
+	  For most arm64, ppc64 and x86 users with lots of address space
 	  a value of 65536 is reasonable and should cause no problems.
 	  On arm and other archs it should not be higher than 32768.
 	  Programs which use vm86 functionality or have some need to map
_

Patches currently in -mm which might be from javierm@redhat.com are

mm-kconfig-mention-arm64-in-default_mmap_min_addr-symbol-help-text.patch

