Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93350819
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 20:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717792319; cv=none; b=lj6NWwVKNWoaqagBPdUb2CIVy/lp2tuCEmMAc6LixPYDhrUKsfI4cMnIofAS39kVSiWPMbsIiojTmcgOaU2b+55IvEHfnU7keuiuyjGv1ebP5VqiiRW7VJPyKlRbJY+LaDV4rgL0WoBr/Kg9pA2ys7zwqZWq2bevnyqMmIkY/p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717792319; c=relaxed/simple;
	bh=clFrZK/VVQ2IObwLTYfZjwhQl3EAQb1sS0VdpbUJ8n0=;
	h=Date:To:From:Subject:Message-Id; b=eCAy51KAgeJBD1hxFnoVZfoAoZEbiOgmJaXNasV3euuNPbMLlWFeu8TU5LuhdqDzARaY2P3vIK/MFj4GiVNxswn04Lof7lCWUbsULMZquwExoxADpt55OiFR3CMVUP25ejf+auVIIRokBZO/UqwxKPcCrh6bVq0a8nOZxaOz1JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dD8jWJeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dD8jWJeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E89C2BBFC;
	Fri,  7 Jun 2024 20:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717792319;
	bh=clFrZK/VVQ2IObwLTYfZjwhQl3EAQb1sS0VdpbUJ8n0=;
	h=Date:To:From:Subject:From;
	b=dD8jWJegk0Q9ZybAAhe2XYLCcO1xVbZ1zRTr4I1AcBHYEFW1ZwhK1QYvENvetnECk
	 cRzYhWfmZbr6sgNUIkV16iIEuj+eGxHQjQuyb8ytL3YaddbcEP4fGTTL2v8+br6EyJ
	 lI/2fnGb2BJb/VvkyZBbBKIjEtUIp3w9UItr+OjQ=
Date: Fri, 07 Jun 2024 13:31:58 -0700
To: mm-commits@vger.kernel.org,javierm@redhat.com,bmasney@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kconfigdebug-document-panic=-command-line-option-and-procfs-entry-for-panic_timeout.patch added to mm-nonmm-unstable branch
Message-Id: <20240607203159.01E89C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/Kconfig.debug: document panic= command line option and procfs entry for PANIC_TIMEOUT
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kconfigdebug-document-panic=-command-line-option-and-procfs-entry-for-panic_timeout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kconfigdebug-document-panic=-command-line-option-and-procfs-entry-for-panic_timeout.patch

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
From: Brian Masney <bmasney@redhat.com>
Subject: lib/Kconfig.debug: document panic= command line option and procfs entry for PANIC_TIMEOUT
Date: Fri, 7 Jun 2024 11:24:43 -0400

PANIC_TIMEOUT can also be controlled with the panic= kernel command line
option and the file /proc/sys/kernel/panic.  Let's document both of these
in the Kconfig help text.

Link: https://lkml.kernel.org/r/20240607152443.925168-1-bmasney@redhat.com
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-document-panic=-command-line-option-and-procfs-entry-for-panic_timeout
+++ a/lib/Kconfig.debug
@@ -1043,7 +1043,9 @@ config PANIC_TIMEOUT
 	  Set the timeout value (in seconds) until a reboot occurs when
 	  the kernel panics. If n = 0, then we wait forever. A timeout
 	  value n > 0 will wait n seconds before rebooting, while a timeout
-	  value n < 0 will reboot immediately.
+	  value n < 0 will reboot immediately. This setting can be overridden
+	  with the kernel command line option panic=, and from userspace via
+	  /proc/sys/kernel/panic.
 
 config LOCKUP_DETECTOR
 	bool
_

Patches currently in -mm which might be from bmasney@redhat.com are

lib-kconfigdebug-document-panic=-command-line-option-and-procfs-entry-for-panic_timeout.patch

