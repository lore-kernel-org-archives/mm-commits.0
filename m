From: akpm@linux-foundation.org
Subject: + coredump-use-from_kuid-kgid-when-formatting-corename.patch
 added to -mm tree
Date: Mon, 18 May 2015 15:45:21 -0700
Message-ID: <555a6b81.fEoYiIobLfYkqG97%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbbERWpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 May 2015 18:45:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: use from_kuid/kgid when formatting corename
has been added to the -mm tree.  Its filename is
     coredump-use-from_kuid-kgid-when-formatting-corename.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-use-from_kuid-kgid-when-formatting-corename.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-use-from_kuid-kgid-when-formatting-corename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: coredump: use from_kuid/kgid when formatting corename

When adding __printf attribute to cn_printf, gcc reports some issues:

  fs/coredump.c:213:5: warning: format '%d' expects argument of type
  'int', but argument 3 has type 'kuid_t' [-Wformat=]
       err = cn_printf(cn, "%d", cred->uid);
       ^
  fs/coredump.c:217:5: warning: format '%d' expects argument of type
  'int', but argument 3 has type 'kgid_t' [-Wformat=]
       err = cn_printf(cn, "%d", cred->gid);
       ^

These warnings come from the fact that the value of uid/gid needs to be
extracted from the kuid_t/kgid_t structure before being used as an
integer.  More precisely, cred->uid and cred->gid need to be converted to
either user-namespace uid/gid or to init_user_ns uid/gid.

Use init_user_ns in order not to break existing ABI, and document this in
Documentation/sysctl/kernel.txt.

While at it, format uid and gid values with %u instead of %d because
uid_t/__kernel_uid32_t and gid_t/__kernel_gid32_t are unsigned int.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    4 ++--
 fs/coredump.c                   |    8 ++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~coredump-use-from_kuid-kgid-when-formatting-corename Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~coredump-use-from_kuid-kgid-when-formatting-corename
+++ a/Documentation/sysctl/kernel.txt
@@ -197,8 +197,8 @@ core_pattern is used to specify a core d
 	%P	global pid (init PID namespace)
 	%i	tid
 	%I	global tid (init PID namespace)
-	%u	uid
-	%g	gid
+	%u	uid (in initial user namespace)
+	%g	gid (in initial user namespace)
 	%d	dump mode, matches PR_SET_DUMPABLE and
 		/proc/sys/fs/suid_dumpable
 	%s	signal number
diff -puN fs/coredump.c~coredump-use-from_kuid-kgid-when-formatting-corename fs/coredump.c
--- a/fs/coredump.c~coredump-use-from_kuid-kgid-when-formatting-corename
+++ a/fs/coredump.c
@@ -209,11 +209,15 @@ static int format_corename(struct core_n
 				break;
 			/* uid */
 			case 'u':
-				err = cn_printf(cn, "%d", cred->uid);
+				err = cn_printf(cn, "%u",
+						from_kuid(&init_user_ns,
+							  cred->uid));
 				break;
 			/* gid */
 			case 'g':
-				err = cn_printf(cn, "%d", cred->gid);
+				err = cn_printf(cn, "%u",
+						from_kgid(&init_user_ns,
+							  cred->gid));
 				break;
 			case 'd':
 				err = cn_printf(cn, "%d",
_

Patches currently in -mm which might be from nicolas.iooss_linux@m4x.org are

coredump-use-from_kuid-kgid-when-formatting-corename.patch
coredump-add-__printf-attribute-to-cn_printf-functions.patch
linux-next.patch

