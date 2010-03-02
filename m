From: akpm@linux-foundation.org
Subject: + kconfig-place-git-sha1-in-config-output-if-in-git-tree.patch added to -mm tree
Date: Tue, 02 Mar 2010 15:10:02 -0800
Message-ID: <201003022310.o22NA2AS002816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963Ab0CBXKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 18:10:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu, mmarek@suse.cz


The patch titled
     kconfig: place git SHA1 in .config output if in git tree
has been added to the -mm tree.  Its filename is
     kconfig-place-git-sha1-in-config-output-if-in-git-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kconfig: place git SHA1 in .config output if in git tree
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Append the SHA1 hash of the current git tree to the kernel version line,
or "[Not git tree]" if run from a non-git tree.  Uses "git log" to print
the hash.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/confdata.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN scripts/kconfig/confdata.c~kconfig-place-git-sha1-in-config-output-if-in-git-tree scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c~kconfig-place-git-sha1-in-config-output-if-in-git-tree
+++ a/scripts/kconfig/confdata.c
@@ -399,10 +399,11 @@ int conf_read(const char *name)
 int conf_write(const char *name)
 {
 	FILE *out;
+	FILE *git;
 	struct symbol *sym;
 	struct menu *menu;
 	const char *basename;
-	char dirname[128], tmpname[128], newname[128];
+	char dirname[128], tmpname[128], newname[128], gitsha[128];
 	int type, l;
 	const char *str;
 	time_t now;
@@ -450,12 +451,20 @@ int conf_write(const char *name)
 	if (env && *env)
 		use_timestamp = 0;
 
+	gitsha[0] = '\0';
+	git = popen("git log --pretty=format:%h -1 2> /dev/null", "r");
+	if (git != NULL) {
+		fscanf(git, " %127s ", gitsha);
+		pclose(git);
+	}
+
 	fprintf(out, _("#\n"
 		       "# Automatically generated make config: don't edit\n"
-		       "# Linux kernel version: %s\n"
+		       "# Linux kernel version: %s %s\n"
 		       "%s%s"
 		       "#\n"),
 		     sym_get_string_value(sym),
+		     gitsha[0] == '\0' ? "[Not git tree]" : gitsha,
 		     use_timestamp ? "# " : "",
 		     use_timestamp ? ctime(&now) : "");
 
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
linux-next.patch
kconfig-place-git-sha1-in-config-output-if-in-git-tree.patch
rcu-remove-init_rcu_head-rcu_head_init-rcu_head.patch
sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch
sysctl-extern-cleanup-rcu.patch

