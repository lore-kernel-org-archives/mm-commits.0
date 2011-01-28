From: akpm@linux-foundation.org
Subject: + xattrh-expose-string-defines-to-userspace.patch added to -mm tree
Date: Thu, 27 Jan 2011 16:43:50 -0800
Message-ID: <201101280043.p0S0hoe6009289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576Ab1A1AoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 19:44:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, jmorris@namei.org, ozan@pardus.org.tr, serue@us.ibm.com, zohar@us.ibm.com


The patch titled
     xattr.h: expose string defines to userspace
has been added to the -mm tree.  Its filename is
     xattrh-expose-string-defines-to-userspace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: xattr.h: expose string defines to userspace
=46rom: Eric Paris <eparis@redhat.com>

af4f136056c9 ("security: move LSM xattrnames to xattr.h") moved the
XATTR_CAPS_SUFFIX define from capability.h to xattr.h.  This makes sens=
e
except it was previously exports to userspace but xattr.h does not expo=
rt
it to userspace.  This patch exports these headers to userspace to fix =
the
ABI regression.

There is some slight possibility that this will cause problems in other
applications which used these #defines differently (wrongly) and I coul=
d
JUST export the capabilities xattr name that we broke.  Does anyonehave=
 an
idea how exposing these headers could cause a problem?

Below is what is being exposed to userspace, included here since it isn=
't
clear exactly what is going to be made available from the patch.

/* Namespaces */
#define XATTR_OS2_PREFIX "os2."
#define XATTR_OS2_PREFIX_LEN (sizeof (XATTR_OS2_PREFIX) - 1)

#define XATTR_SECURITY_PREFIX   "security."
#define XATTR_SECURITY_PREFIX_LEN (sizeof (XATTR_SECURITY_PREFIX) - 1)

#define XATTR_SYSTEM_PREFIX "system."
#define XATTR_SYSTEM_PREFIX_LEN (sizeof (XATTR_SYSTEM_PREFIX) - 1)

#define XATTR_TRUSTED_PREFIX "trusted."
#define XATTR_TRUSTED_PREFIX_LEN (sizeof (XATTR_TRUSTED_PREFIX) - 1)

#define XATTR_USER_PREFIX "user."
#define XATTR_USER_PREFIX_LEN (sizeof (XATTR_USER_PREFIX) - 1)

/* Security namespace */
#define XATTR_SELINUX_SUFFIX "selinux"
#define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX

#define XATTR_SMACK_SUFFIX "SMACK64"
#define XATTR_SMACK_IPIN "SMACK64IPIN"
#define XATTR_SMACK_IPOUT "SMACK64IPOUT"
#define XATTR_NAME_SMACK XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
#define XATTR_NAME_SMACKIPIN    XATTR_SECURITY_PREFIX XATTR_SMACK_IPIN
#define XATTR_NAME_SMACKIPOUT   XATTR_SECURITY_PREFIX XATTR_SMACK_IPOUT

#define XATTR_CAPS_SUFFIX "capability"
#define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX

Reported-by: Ozan =C7aglayan <ozan@pardus.org.tr>
Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xattr.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/xattr.h~xattrh-expose-string-defines-to-userspa=
ce include/linux/xattr.h
--- a/include/linux/xattr.h~xattrh-expose-string-defines-to-userspace
+++ a/include/linux/xattr.h
@@ -13,10 +13,6 @@
 #define XATTR_CREATE	0x1	/* set value, fail if attr already exists */
 #define XATTR_REPLACE	0x2	/* set value, fail if attr does not exist */
=20
-#ifdef  __KERNEL__
-
-#include <linux/types.h>
