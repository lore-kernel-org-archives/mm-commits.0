From: akpm@linux-foundation.org
Subject: + fs-proc-add-help-for-config_proc_children.patch added to -mm
 tree
Date: Wed, 08 Jul 2015 15:09:21 -0700
Message-ID: <559d9f91.v5wWm4vzEgZMHlCz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbGHWJW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2015 18:09:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iago@endocode.com, jdelvare@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, proc: add help for CONFIG_PROC_CHILDREN
has been added to the -mm tree.  Its filename is
     fs-proc-add-help-for-config_proc_children.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-add-help-for-confi=
g_proc_children.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-add-help-for-confi=
g_proc_children.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Iago L=F3pez Galeiras <iago@endocode.com>
Subject: fs, proc: add help for CONFIG_PROC_CHILDREN

The purpose of the option was documented in
Documentation/filesystems/proc.txt but the help text was missing.

Add small help text that also points to the documentation.

Signed-off-by: Iago L=F3pez Galeiras <iago@endocode.com>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Kconfig |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/proc/Kconfig~fs-proc-add-help-for-config_proc_children fs/=
proc/Kconfig
--- a/fs/proc/Kconfig~fs-proc-add-help-for-config_proc_children
+++ a/fs/proc/Kconfig
@@ -75,3 +75,9 @@ config PROC_PAGE_MONITOR
 config PROC_CHILDREN
 	bool "Include /proc/<pid>/task/<tid>/children file"
 	default n
+	help
+	  Provides a fast way to retrieve first level children pids of a task=
=2E See
+	  <file:Documentation/filesystems/proc.txt> for more information.
+
+	  Say Y if you are running any user-space software which takes benefi=
t from
+	  this interface. For example, rkt is such a piece of software.
_

Patches currently in -mm which might be from iago@endocode.com are

fs-proc-add-help-for-config_proc_children.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
