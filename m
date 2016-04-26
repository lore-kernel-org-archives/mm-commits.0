From: akpm@linux-foundation.org
Subject: + localmodconfig-reset-certificate-paths.patch added to -mm tree
Date: Tue, 26 Apr 2016 16:21:48 -0700
Message-ID: <571ff80c.b5W0X5emcPkzdMaD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbcDZXVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2016 19:21:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bpoirier@suse.com, mmarek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: localmodconfig: reset certificate paths
has been added to the -mm tree.  Its filename is
     localmodconfig-reset-certificate-paths.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/localmodconfig-reset-certificate-paths.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/localmodconfig-reset-certificate-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Benjamin Poirier <bpoirier@suse.com>
Subject: localmodconfig: reset certificate paths

When using `make localmodconfig` and friends, if the input config comes
from a kernel that was built in a different environment (for example, the
canonical case of using localmodconfig to trim a distribution kernel
config) the key files for module signature checking will not be available
and should be regenerated or omitted.  Otherwise, the user will be faced
with annoying errors when trying to build with the generated .config:

make[1]: *** No rule to make target 'keyring.crt', needed by 'certs/x509_certificate_list'.  Stop.
Makefile:1576: recipe for target 'certs/' failed

Link: http://lkml.kernel.org/r/1461696721-3001-1-git-send-email-bpoirier@suse.com

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/streamline_config.pl |   34 +++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff -puN scripts/kconfig/streamline_config.pl~localmodconfig-reset-certificate-paths scripts/kconfig/streamline_config.pl
--- a/scripts/kconfig/streamline_config.pl~localmodconfig-reset-certificate-paths
+++ a/scripts/kconfig/streamline_config.pl
@@ -610,6 +610,40 @@ foreach my $line (@config_file) {
 	next;
     }
 
+    if (/CONFIG_MODULE_SIG_KEY="(.+)"/) {
+        my $orig_cert = $1;
+        my $default_cert = "certs/signing_key.pem";
+
+        # Check that the logic in this script still matches the one in Kconfig
+        if (!defined($depends{"MODULE_SIG_KEY"}) ||
+            $depends{"MODULE_SIG_KEY"} !~ /"\Q$default_cert\E"/) {
+            print STDERR "WARNING: MODULE_SIG_KEY assertion failure, ",
+                "update needed to ", __FILE__, " line ", __LINE__, "\n";
+            print;
+        } elsif ($orig_cert ne $default_cert && ! -f $orig_cert) {
+            print STDERR "Module signature verification enabled but ",
+                "module signing key \"$orig_cert\" not found. Resetting ",
+                "signing key to default value.\n";
+            print "CONFIG_MODULE_SIG_KEY=\"$default_cert\"\n";
+        } else {
+            print;
+        }
+        next;
+    }
+
+    if (/CONFIG_SYSTEM_TRUSTED_KEYS="(.+)"/) {
+        my $orig_keys = $1;
+
+        if (! -f $orig_keys) {
+            print STDERR "System keyring enabled but keys \"$orig_keys\" ",
+                "not found. Resetting keys to default value.\n";
+            print "CONFIG_SYSTEM_TRUSTED_KEYS=\"\"\n";
+        } else {
+            print;
+        }
+        next;
+    }
+
     if (/^(CONFIG.*)=(m|y)/) {
 	if (defined($configs{$1})) {
 	    if ($localyesconfig) {
_

Patches currently in -mm which might be from bpoirier@suse.com are

localmodconfig-fix-parsing-of-kconfig-source-statements.patch
localmodconfig-recognize-more-keywords-that-end-a-menu-entry.patch
localmodconfig-fix-parsing-of-help-text.patch
localmodconfig-add-missing-to-reference-a-variable.patch
localmodconfig-reset-certificate-paths.patch
localmodconfig-fix-whitespace-repeat-count-after-tristate.patch

