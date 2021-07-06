Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9A5C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09FF661C72
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhGFTK6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231778AbhGFTKz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:10:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8718061C6F;
        Tue,  6 Jul 2021 19:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598496;
        bh=V++KrYPpQOT9cTU0uDQg5hFa3Al9TDRTNmdL89IU4sM=;
        h=Date:From:To:Subject:From;
        b=WbvZP8fRis4BEDyP2bCxsT1s3AQsIrkE46HY1n8g8uI3x3TRUw8GNtw8uhqTDwbCq
         n+9iQkETtGWPJOnXPtcQfpfC65slmOwsoLgzRhSIswKZwwijKI0wowwIveMHnzEppn
         kHUp49LKLnkeBgEliLr7m7WR0XpCCBil/h0YYHXY=
Date:   Tue, 06 Jul 2021 12:08:16 -0700
From:   akpm@linux-foundation.org
To:     masahiroy@kernel.org, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, warthog9@kernel.org
Subject:  [merged]
 streamline_configpl-make-spacing-consistent.patch removed from -mm tree
Message-ID: <20210706190816.eqRzc1oHl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: streamline_config.pl: make spacing consistent
has been removed from the -mm tree.  Its filename was
     streamline_configpl-make-spacing-consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: streamline_config.pl: make spacing consistent

Patch series "streamline_config.pl: Fix Perl spacing".

Talking with John Hawley about how vim and emacs deal with Perl files with
respect to tabs and spaces, I found that some of my Perl code in the
kernel had inconsistent spacing.  The way emacs handles Perl by default is
to use 4 spaces per indent, but make all 8 spaces into a single tab.  Vim
does not do this by default.  But if you add the vim variable control:

 # vim: softtabstop=4

to a perl file, it makes vim behave the same way as emacs.

The first patch is to change all 8 spaces into a single tab (mostly from
people editing the file with vim).  The next patch adds the softtabstop
variable to make vim act like emacs by default.


This patch (of 2):

As Perl code tends to have 4 space indentation, but uses tabs for every 8
spaces, make that consistent in the streamline_config.pl code.  Replace
all 8 spaces with a single tab.

Link: https://lkml.kernel.org/r/20210322214032.133596267@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: "John (Warthog9) Hawley" <warthog9@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/streamline_config.pl |   74 ++++++++++++-------------
 1 file changed, 37 insertions(+), 37 deletions(-)

--- a/scripts/kconfig/streamline_config.pl~streamline_configpl-make-spacing-consistent
+++ a/scripts/kconfig/streamline_config.pl
@@ -601,12 +601,12 @@ if (defined($ENV{'LMC_KEEP'})) {
 sub in_preserved_kconfigs {
     my $kconfig = $config2kfile{$_[0]};
     if (!defined($kconfig)) {
-        return 0;
+	return 0;
     }
     foreach my $excl (@preserved_kconfigs) {
-        if($kconfig =~ /^$excl/) {
-            return 1;
-        }
+	if($kconfig =~ /^$excl/) {
+	    return 1;
+	}
     }
     return 0;
 }
@@ -629,52 +629,52 @@ foreach my $line (@config_file) {
     }
 
     if (/CONFIG_MODULE_SIG_KEY="(.+)"/) {
-        my $orig_cert = $1;
-        my $default_cert = "certs/signing_key.pem";
+	my $orig_cert = $1;
+	my $default_cert = "certs/signing_key.pem";
 
-        # Check that the logic in this script still matches the one in Kconfig
-        if (!defined($depends{"MODULE_SIG_KEY"}) ||
-            $depends{"MODULE_SIG_KEY"} !~ /"\Q$default_cert\E"/) {
-            print STDERR "WARNING: MODULE_SIG_KEY assertion failure, ",
-                "update needed to ", __FILE__, " line ", __LINE__, "\n";
-            print;
-        } elsif ($orig_cert ne $default_cert && ! -f $orig_cert) {
-            print STDERR "Module signature verification enabled but ",
-                "module signing key \"$orig_cert\" not found. Resetting ",
-                "signing key to default value.\n";
-            print "CONFIG_MODULE_SIG_KEY=\"$default_cert\"\n";
-        } else {
-            print;
-        }
-        next;
+	# Check that the logic in this script still matches the one in Kconfig
+	if (!defined($depends{"MODULE_SIG_KEY"}) ||
+	    $depends{"MODULE_SIG_KEY"} !~ /"\Q$default_cert\E"/) {
+	    print STDERR "WARNING: MODULE_SIG_KEY assertion failure, ",
+		"update needed to ", __FILE__, " line ", __LINE__, "\n";
+	    print;
+	} elsif ($orig_cert ne $default_cert && ! -f $orig_cert) {
+	    print STDERR "Module signature verification enabled but ",
+		"module signing key \"$orig_cert\" not found. Resetting ",
+		"signing key to default value.\n";
+	    print "CONFIG_MODULE_SIG_KEY=\"$default_cert\"\n";
+	} else {
+	    print;
+	}
+	next;
     }
 
     if (/CONFIG_SYSTEM_TRUSTED_KEYS="(.+)"/) {
-        my $orig_keys = $1;
+	my $orig_keys = $1;
 
-        if (! -f $orig_keys) {
-            print STDERR "System keyring enabled but keys \"$orig_keys\" ",
-                "not found. Resetting keys to default value.\n";
-            print "CONFIG_SYSTEM_TRUSTED_KEYS=\"\"\n";
-        } else {
-            print;
-        }
-        next;
+	if (! -f $orig_keys) {
+	    print STDERR "System keyring enabled but keys \"$orig_keys\" ",
+		"not found. Resetting keys to default value.\n";
+	    print "CONFIG_SYSTEM_TRUSTED_KEYS=\"\"\n";
+	} else {
+	    print;
+	}
+	next;
     }
 
     if (/^(CONFIG.*)=(m|y)/) {
-        if (in_preserved_kconfigs($1)) {
-            dprint "Preserve config $1";
-            print;
-            next;
-        }
+	if (in_preserved_kconfigs($1)) {
+	    dprint "Preserve config $1";
+	    print;
+	    next;
+	}
 	if (defined($configs{$1})) {
 	    if ($localyesconfig) {
-	        $setconfigs{$1} = 'y';
+		$setconfigs{$1} = 'y';
 		print "$1=y\n";
 		next;
 	    } else {
-	        $setconfigs{$1} = $2;
+		$setconfigs{$1} = $2;
 	    }
 	} elsif ($2 eq "m") {
 	    print "# $1 is not set\n";
_

Patches currently in -mm which might be from rostedt@goodmis.org are


