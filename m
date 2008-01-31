From: akpm@linux-foundation.org
Subject: + getdelays-fix-gcc-warnings.patch added to -mm tree
Date: Thu, 31 Jan 2008 15:57:36 -0800
Message-ID: <200801312357.m0VNvaYO017896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41659 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965011AbYBAADb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 19:03:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, balbir@linux.vnet.ibm.com


The patch titled
     getdelays: fix gcc warnings
has been added to the -mm tree.  Its filename is
     getdelays-fix-gcc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: getdelays: fix gcc warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix gcc warnings in getdelays.c:

Documentation/accounting/getdelays.c: In function 'task_context_switch_counts':
Documentation/accounting/getdelays.c:214: warning: format '%15lu' expects type 'long unsigned int', but argument 4 has type '__u64'
Documentation/accounting/getdelays.c:214: warning: format '%15lu' expects type 'long unsigned int', but argument 5 has type '__u64'
Documentation/accounting/getdelays.c: In function 'main':
Documentation/accounting/getdelays.c:402: warning: format '%d' expects type 'int', but argument 2 has type 'long unsigned int'
Documentation/accounting/getdelays.c: In function 'get_family_id':
Documentation/accounting/getdelays.c:171: warning: 'id' may be used uninitialized in this function

One warning is not a problem and can be dismissed:
Documentation/accounting/getdelays.c: In function 'main':
Documentation/accounting/getdelays.c:236: warning: 'cmd_type' may be used uninitialized in this function

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/accounting/getdelays.c~getdelays-fix-gcc-warnings Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~getdelays-fix-gcc-warnings
+++ a/Documentation/accounting/getdelays.c
@@ -168,7 +168,7 @@ int get_family_id(int sd)
 		char buf[256];
 	} ans;
 
-	int id, rc;
+	int id = 0, rc;
 	struct nlattr *na;
 	int rep_len;
 
@@ -209,7 +209,7 @@ void print_delayacct(struct taskstats *t
 void task_context_switch_counts(struct taskstats *t)
 {
 	printf("\n\nTask   %15s%15s\n"
-	       "       %15lu%15lu\n",
+	       "       %15llu%15llu\n",
 	       "voluntary", "nonvoluntary",
 	       t->nvcsw, t->nivcsw);
 }
@@ -399,7 +399,7 @@ int main(int argc, char *argv[])
 			goto done;
 		}
 
-		PRINTF("nlmsghdr size=%d, nlmsg_len=%d, rep_len=%d\n",
+		PRINTF("nlmsghdr size=%zu, nlmsg_len=%d, rep_len=%d\n",
 		       sizeof(struct nlmsghdr), msg.n.nlmsg_len, rep_len);
 
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
docbook-fix-drivers-base-class-warning.patch
ia64-aliasing-test-fix-gcc-warnings-on-non-ia64.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
