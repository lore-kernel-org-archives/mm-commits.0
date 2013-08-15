From: akpm@linux-foundation.org
Subject: + coredump-add-new-%p-variable-in-core_pattern.patch added to -mm tree
Date: Thu, 15 Aug 2013 13:47:28 -0700
Message-ID: <520d3e60.Gn+Tmtyv1LVyhY16%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3HOUr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 16:47:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, serge.hallyn@ubuntu.com, hans.feldt@ericsson.com, ebiederm@xmission.com, apw@canonical.com, stgraber@ubuntu.com

Subject: + coredump-add-new-%p-variable-in-core_pattern.patch added to -mm tree
To: stgraber@ubuntu.com,apw@canonical.com,ebiederm@xmission.com,hans.feldt@ericsson.com,serge.hallyn@ubuntu.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 13:47:28 -0700


The patch titled
     Subject: [PATCH] coredump: Add new %P variable in core_pattern
has been added to the -mm tree.  Its filename is
     coredump-add-new-%p-variable-in-core_pattern.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-add-new-%p-variable-in-core_pattern.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-add-new-%p-variable-in-core_pattern.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stéphane Graber <stgraber@ubuntu.com>
Subject: [PATCH] coredump: Add new %P variable in core_pattern

Add a new %P variable to be used in core_pattern.  This variable contains
the global PID (PID in the init namespace) as %p contains the PID in the
current namespace which isn't always what we want.

The main use for this is to make it easier to handle crashes that happened
within a container.  With that new variables it's possible to have the
crashes dumped into the container or forwarded to the host with the right
PID (from the host's point of view).

Signed-off-by: Stéphane Graber <stgraber@ubuntu.com>
Reported-by: Hans Feldt <hans.feldt@ericsson.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andy Whitcroft <apw@canonical.com>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    1 +
 fs/coredump.c                   |    5 +++++
 2 files changed, 6 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~coredump-add-new-%p-variable-in-core_pattern Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~coredump-add-new-%p-variable-in-core_pattern
+++ a/Documentation/sysctl/kernel.txt
@@ -182,6 +182,7 @@ core_pattern is used to specify a core d
 	%<NUL>	'%' is dropped
 	%%	output one '%'
 	%p	pid
+	%P	global pid (init PID namespace)
 	%u	uid
 	%g	gid
 	%d	dump mode, matches PR_SET_DUMPABLE and
diff -puN fs/coredump.c~coredump-add-new-%p-variable-in-core_pattern fs/coredump.c
--- a/fs/coredump.c~coredump-add-new-%p-variable-in-core_pattern
+++ a/fs/coredump.c
@@ -190,6 +190,11 @@ static int format_corename(struct core_n
 				err = cn_printf(cn, "%d",
 					      task_tgid_vnr(current));
 				break;
+			/* global pid */
+			case 'P':
+				err = cn_printf(cn, "%d",
+					      task_tgid_nr(current));
+				break;
 			/* uid */
 			case 'u':
 				err = cn_printf(cn, "%d", cred->uid);
_

Patches currently in -mm which might be from stgraber@ubuntu.com are

coredump-add-new-%p-variable-in-core_pattern.patch

