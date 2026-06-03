Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F379136EAA4
	for <mm-commits@vger.kernel.org>; Wed,  3 Jun 2026 20:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780518851; cv=none; b=HzotOAvjjhNJQ53RqJqGQosFvqjMyeVQIKuxTyiTTD2ITrFZxhLjqdYDUkITeQotfVAHo308gVJvYDAZJcxHt2TW9nYXsyjWT7nfu4TDKcXtIMRV6gIF9yMJXcprgzH6OU0B4QNGnwgXqCfkAeKsb+/xStNYIt61sIvRK+OK9OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780518851; c=relaxed/simple;
	bh=Ooa77Y4ZQH3AB+RIH01+g/l3u6zookCsXBz4DN+oEm0=;
	h=Date:To:From:Subject:Message-Id; b=AwJ9n8EII7MNIFul3/mbdQlgYDtFdqDMtCtFN2a7HDrfqH/bMXuKZJtAlnTOfoX37KYPjcAqbSSO5Mmphoe/3XJrniUhW2rVnYCkr6a3Wf3hoqRyuwGmYpgbwvTBWoPpc+1iVFJeT2ynT2GircwxeGQwJwHto1NkNX+awXvRLnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xrZFoluK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xrZFoluK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA8D1F00893;
	Wed,  3 Jun 2026 20:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780518849;
	bh=d5YY5A4FLWNVIy0zHkurYtndFByR2ZUUGV5zUFhjuEw=;
	h=Date:To:From:Subject;
	b=xrZFoluKW2BFyU4z6X4VdXHYEWgqbmgnutHzxqG7n8IMJLaKU9fxauYcLuemiU5NC
	 Q/zy/0xft7Gocb3RwWIy7gDI3+X8QBSYXtcAdWyfOoFcu2CIqlAdwFPt4lFRZjMKtO
	 cout+pO5jmOjxwo9QoMUoEPDbUnH8l9vSIKHxNew=
Date: Wed, 03 Jun 2026 13:34:09 -0700
To: mm-commits@vger.kernel.org,serge@hallyn.com,paul@paul-moore.com,john.johansen@canonical.com,jmorris@namei.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch added to mm-nonmm-unstable branch
Message-Id: <20260603203409.7AA8D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: security/apparmor/apparmorfs.c: conditionally compile get_loaddata_common_ref()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: security/apparmor/apparmorfs.c: conditionally compile get_loaddata_common_ref()
Date: Wed Jun  3 01:30:46 PM PDT 2026

Some config did this:

security/apparmor/apparmorfs.c:177:28: warning: 'get_loaddata_common_ref' defined but not used [-Wunused-function]
  177 | static struct aa_loaddata *get_loaddata_common_ref(struct aa_common_ref *ref)

get_loaddata_common_ref() is only used if
CONFIG_SECURITY_APPARMOR_EXPORT_BINARY=y.

(Or of course move the function into that block if maintainers perfer)

Cc: John Johansen <john.johansen@canonical.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/apparmor/apparmorfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/apparmor/apparmorfs.c~security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref
+++ a/security/apparmor/apparmorfs.c
@@ -174,6 +174,7 @@ static struct aa_proxy *get_proxy_common
 	return NULL;
 }
 
+#ifdef CONFIG_SECURITY_APPARMOR_EXPORT_BINARY
 static struct aa_loaddata *get_loaddata_common_ref(struct aa_common_ref *ref)
 {
 	if (ref)
@@ -181,6 +182,7 @@ static struct aa_loaddata *get_loaddata_
 						      count));
 	return NULL;
 }
+#endif
 
 static void aa_put_common_ref(struct aa_common_ref *ref)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-switch-deferred-split-shrinker-to-list_lru-fix.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch

