From: akpm@linux-foundation.org
Subject: + make-config_fhandle-default-y.patch added to -mm tree
Date: Thu, 31 Mar 2016 13:22:09 -0700
Message-ID: <56fd86f1.m/fK9T1qvezwony9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791AbcCaUWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2016 16:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, richard.weinberger@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Make CONFIG_FHANDLE default y
has been added to the -mm tree.  Its filename is
     make-config_fhandle-default-y.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/make-config_fhandle-default-y.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/make-config_fhandle-default-y.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: Make CONFIG_FHANDLE default y

Newer Fedora and OpenSUSE didn't boot with my standard configuration.  It
took me some time to figure out why, in fact I had to write a script to
try different config options systematically.

The problem is that something (systemd) in dracut depends on
CONFIG_FHANDLE, which adds open by file handle syscalls.

While it is set in defconfigs it is very easy to miss when updating older
configs because it is not default y.

Make it default y and also depend on EXPERT, as dracut use is likely
widespread.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN init/Kconfig~make-config_fhandle-default-y init/Kconfig
--- a/init/Kconfig~make-config_fhandle-default-y
+++ a/init/Kconfig
@@ -272,8 +272,9 @@ config CROSS_MEMORY_ATTACH
 	  See the man page for more details.
 
 config FHANDLE
-	bool "open by fhandle syscalls"
+	bool "open by fhandle syscalls" if EXPERT
 	select EXPORTFS
+	default y
 	help
 	  If you say Y here, a user level program will be able to map
 	  file names to handle and then later use the handle for
_

Patches currently in -mm which might be from ak@linux.intel.com are

make-config_fhandle-default-y.patch

