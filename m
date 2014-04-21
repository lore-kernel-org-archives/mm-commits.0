From: akpm@linux-foundation.org
Subject: [merged]
 init-kconfig-move-the-trusted-keyring-config-option-to-general-setup.patch
 removed from -mm tree
Date: Mon, 21 Apr 2014 11:10:53 -0700
Message-ID: <53555f2d.wOxZFYzt6yCIjiBH%akpm__16621.3270546452$1398103869$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaDUSKy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 14:10:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, dhowells@redhat.com, pefoley2@pefoley.com

Subject: [merged] init-kconfig-move-the-trusted-keyring-config-option-to-general-setup.patch removed from -mm tree
To: pefoley2@pefoley.com,dhowells@redhat.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 11:10:53 -0700


The patch titled
     Subject: init/Kconfig: move the trusted keyring config option to general setup
has been removed from the -mm tree.  Its filename was
     init-kconfig-move-the-trusted-keyring-config-option-to-general-setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Foley <pefoley2@pefoley.com>
Subject: init/Kconfig: move the trusted keyring config option to general setup

The SYSTEM_TRUSTED_KEYRING config option is not in any menu, causing it to
show up in the toplevel of the kernel configuration.  Fix this by moving
it under the General Setup menu.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN init/Kconfig~init-kconfig-move-the-trusted-keyring-config-option-to-general-setup init/Kconfig
--- a/init/Kconfig~init-kconfig-move-the-trusted-keyring-config-option-to-general-setup
+++ a/init/Kconfig
@@ -1646,6 +1646,18 @@ config MMAP_ALLOW_UNINITIALIZED
 
 	  See Documentation/nommu-mmap.txt for more information.
 
+config SYSTEM_TRUSTED_KEYRING
+	bool "Provide system-wide ring of trusted keys"
+	depends on KEYS
+	help
+	  Provide a system keyring to which trusted keys can be added.  Keys in
+	  the keyring are considered to be trusted.  Keys may be added at will
+	  by the kernel from compiled-in data and from hardware key stores, but
+	  userspace may only add extra keys if those keys can be verified by
+	  keys already in the keyring.
+
+	  Keys in this keyring are used by module signature checking.
+
 config PROFILING
 	bool "Profiling support"
 	help
@@ -1681,18 +1693,6 @@ config BASE_SMALL
 	default 0 if BASE_FULL
 	default 1 if !BASE_FULL
 
-config SYSTEM_TRUSTED_KEYRING
-	bool "Provide system-wide ring of trusted keys"
-	depends on KEYS
-	help
-	  Provide a system keyring to which trusted keys can be added.  Keys in
-	  the keyring are considered to be trusted.  Keys may be added at will
-	  by the kernel from compiled-in data and from hardware key stores, but
-	  userspace may only add extra keys if those keys can be verified by
-	  keys already in the keyring.
-
-	  Keys in this keyring are used by module signature checking.
