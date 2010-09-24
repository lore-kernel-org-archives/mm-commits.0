From: akpm@linux-foundation.org
Subject: + autofs-only-declare-function-when-config_compat-is-defined.patch added to -mm tree
Date: Fri, 24 Sep 2010 12:18:27 -0700
Message-ID: <201009241918.o8OJIRXi020089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757522Ab0IXTSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 15:18:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nm127@freemail.hu, arnd@arndb.de, fweisbec@gmail.com, raven@themaw.net


The patch titled
     autofs: only declare function when CONFIG_COMPAT is defined
has been added to the -mm tree.  Its filename is
     autofs-only-declare-function-when-config_compat-is-defined.patch

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
Subject: autofs: only declare function when CONFIG_COMPAT is defined
=46rom: M=E1rton N=E9meth <nm127@freemail.hu>

=46ix the following warning when CONFIG_COMPAT is not defined:

fs/autofs/root.c:30: warning: `autofs_root_compat_ioctl' declared `stat=
ic' but never defined

Signed-off-by: M=E1rton N=E9meth <nm127@freemail.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/root.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/autofs/root.c~autofs-only-declare-function-when-config_com=
pat-is-defined fs/autofs/root.c
--- a/fs/autofs/root.c~autofs-only-declare-function-when-config_compat-=
is-defined
+++ a/fs/autofs/root.c
@@ -27,7 +27,9 @@ static int autofs_root_unlink(struct ino
 static int autofs_root_rmdir(struct inode *,struct dentry *);
 static int autofs_root_mkdir(struct inode *,struct dentry *,int);
 static long autofs_root_ioctl(struct file *,unsigned int,unsigned long=
);
+#ifdef CONFIG_COMPAT
 static long autofs_root_compat_ioctl(struct file *,unsigned int,unsign=
ed long);
+#endif
=20
 const struct file_operations autofs_root_operations =3D {
 	.llseek		=3D generic_file_llseek,
_

Patches currently in -mm which might be from nm127@freemail.hu are

autofs-only-declare-function-when-config_compat-is-defined.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
