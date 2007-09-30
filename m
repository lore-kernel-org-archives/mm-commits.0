From: akpm@linux-foundation.org
Subject: + smack-simplified-mandatory-access-control-kernel.patch added to -mm tree
Date: Sun, 30 Sep 2007 01:16:31 -0700
Message-ID: <200709300816.l8U8GVA9020438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753895AbXI3ISV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 30 Sep 2007 04:18:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: casey@schaufler-ca.com, ak@suse.de, chrisw@sous-sol.org, crispin@novell.com, jmorris@namei.org, method@manicmethod.com, mrmacman_g4@mac.com, paul.moore@hp.com, sds@tycho.nsa.gov


The patch titled
     Smack: Simplified Mandatory Access Control Kernel
has been added to the -mm tree.  Its filename is
     smack-simplified-mandatory-access-control-kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Smack: Simplified Mandatory Access Control Kernel
From: Casey Schaufler <casey@schaufler-ca.com>

Smack is the Simplified Mandatory Access Control Kernel.

Smack implements mandatory access control (MAC) using labels attached to
tasks and data containers, including files, SVIPC, and other tasks.  Smack
is a kernel based scheme that requires an absolute minimum of application
support and a very small amount of configuration data.

Smack is implemented as a clean LSM.  It requires no external code changes
and the patch modifies only the Kconfig and Makefile in the security
directory.  Smack uses extended attributes and provides a set of general
mount options, borrowing technics used elsewhere.  Smack uses netlabel for
CIPSO labeling.  Smack provides a pseudo-filesystem smackfs that is used
for manipulation of system Smack attributes.

The patch, patches for ls and sshd, a README, a startup script, and x86
binaries for ls and sshd are also available on

    http://www.schaufler-ca.com

The patch has been tested with 2.6.22, 2.6.23-rc8, and 2.6.23-rc8-mm2. 
Development has been done using Fedora Core 7 in a virtual machine
environment and on an old Sony laptop.

Smack provides mandatory access controls based on the label attached to a
task and the label attached to the object it is attempting to access. 
Smack labels are deliberately short (1-23 characters) text strings.  Single
character labels using special characters are reserved for system use.  The
only operation applied to Smack labels is equality comparison.  No
wildcards or expressions, regular or otherwise, are used.

A file always gets the Smack label of the task that created it.

Smack defines and uses these labels:

    "*" - pronounced "star"
    "_" - pronounced "floor"
    "^" - pronounced "hat"
    "?" - pronounced "huh"

The access rules enforced by Smack are, in order:

1. Any access requested by a task labeled "*" is denied.
2. A read or execute access requested by a task labeled "^"
   is permitted.
3. A read or execute access requested on an object labeled "_"
   is permitted.
4. Any access requested on an object labeled "*" is permitted.
5. Any access requested by a task on an object with the same
   label is permitted.
6. Any access requested that is explicitly defined in the loaded
   rule set is permitted.
7. Any other access is denied.

Rules may be explicitly defined by writing subject,object,access triples to
/smack/load.

Smack rule sets can be easily defined that describe Bell&LaPadula
sensitivity, Biba integrity, and a variety of interesting configurations. 
Smack rule sets can be modified on the fly to accomodate changes in the
operating environment or even the time of day.

Some practical use cases:

Hierarchical levels.  The less common of the two usual uses for MLS systems
is to define hierarchical levels, often unclassified, confidential, secret,
and so on.  To set up smack to support this, these rules could be defined:

   C        Unclass rx
   S        C       rx
   S        Unclass rx
   TS       S       rx
   TS       C       rx
   TS       Unclass rx

A TS process can read S, C, and Unclass data, but cannot write it.  An S
process can read C and Unclass.  Note that specifying that TS can read S
and S can read C does not imply TS can read C, it has to be explicitly
stated.

Non-hierarchical categories.  This is the more common of the usual uses for
an MLS system.  Since the default rule is that a subject cannot access an
object with a different label no access rules are required to implement
compartmentalization.

A case that the Bell & LaPadula policy does not allow is demonstrated with
this Smack access rule:

A case that Bell&LaPadula does not allow that Smack does:

    ESPN    ABC   r
    ABC     ESPN  r

On my portable video device I have two applications, one that shows ABC
programming and the other ESPN programming.  ESPN wants to show me sport
stories that show up as news, and ABC will only provide minimal information
about a sports story if ESPN is covering it.  Each side can look at the
other's info, neither can change the other.  Neither can see what FOX is up
to, which is just as well all things considered.

Another case that I especially like:

    SatData Guard   w
    Guard   Publish w

A program running with the Guard label opens a UDP socket and accepts
messages sent by a program running with a SatData label.  The Guard program
inspects the message to ensure it is wholesome and if it is sends it to a
program running with the Publish label.  This program then puts the
information passed in an appropriate place.  Note that the Guard program
cannot write to a Publish file system object because file system semanitic
require read as well as write.

The four cases (categories, levels, mutual read, guardbox) here
are all quite real, and problems I've been asked to solve over
the years. The first two are easy to do with traditonal MLS systems
while the last two you can't without invoking privilege, at least
for a while.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Crispin Cowan <crispin@novell.com>
Cc: Joshua Brindle <method@manicmethod.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Moore <paul.moore@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Smack.txt       |  104 +
 security/Kconfig              |    1 
 security/Makefile             |    2 
 security/smack/Kconfig        |   10 
 security/smack/Makefile       |    9 
 security/smack/smack.h        |  207 ++
 security/smack/smack_access.c |  345 ++++
 security/smack/smack_lsm.c    | 2685 ++++++++++++++++++++++++++++++++
 security/smack/smackfs.c      | 1201 ++++++++++++++
 9 files changed, 4564 insertions(+)

diff -puN /dev/null Documentation/Smack.txt
--- /dev/null
+++ a/Documentation/Smack.txt
@@ -0,0 +1,104 @@
+
+
+    "Good for you, you've decided to clean the elevator!"
+    - The Elevator, from Dark Star
+
+Smack is the the Simplified Mandatory Access Control Kernel.
+Smack is a kernel based implementation of mandatory access
+control that includes simplicity in its primary design goals.
+
+Smack does not implement Domain Type Enforcement (DTE). If
+you want DTE Linux has an implementation called SELinux.
+Those who really want DTE are encouraged to use SELinux.
+Those who don't know what DTE is are encouraged to compare
+SELinux with Smack to determine which mechanisms are best
+suited to the problem at hand.
+
+Smack consists of three major components:
+    - The kernel
+    - A start-up script and a few modified applications
+    - Configuration data
+
+The kernel component of Smack is implemented as a Linux
+Security Modules (LSM) module. It requires netlabel and
+works best with file systems that support extended attributes,
+although xattr support is not strictly required. The Smack
+patch is (currently) self contained, except for Kconfig
+and Makefile changes in the security directory. It is safe
+to run a Smack kernel under a "vanilla" distribution.
+Smack kernels use the CIPSO IP option. Some network
+configurations are intolerant of IP options and can impede
+access to systems that use them as Smack does.
+
+The startup script etc-init.d-smack should be installed
+in /etc/init.d/smack and should be invoked early in the
+start-up process. On Fedora rc5.d/S02smack is recommended.
+This script ensures that certain devices have the correct
+Smack attributes and loads the Smack configuration if
+any is defined.
+
+A version of "ls" that provides a "-M" option to display
+Smack labels on long listing is available.
+
+A hacked version of sshd that allows network logins by users
+with specific Smack labels is available. This version does
+not work for scp. You must set the /etc/ssh/sshd_config
+line:
+   UsePrivilegeSeparation no
+
+The format of /etc/smack/usr is:
+
+   username smack
+
+In keeping with the intent of Smack, configuration data is
+minimal and not strictly required. The most important
+configuration step is mounting the smackfs pseudo filesystem.
+
+Add this line to /etc/fstab:
+
+    smackfs /smack smackfs smackfsdef=* 0 0
+
+and create the /smack directory for mounting.
+
+Smack uses extended attributes (xattrs) to store file labels.
+The command to set a Smack label on a file is:
+
+    # attr -S -s SMACK64 -V "value" path
+
+NOTE: Smack labels are limited to 23 characters. The attr command
+      does not enforce this restriction and can be used to set
+      invalid Smack labels on files.
+
+The smackfs filesystem treats symbolic links in a special way.
+The Smack label of the process is appended to the link value
+during resolution. To provide a /tmp that is available to users
+with multiple labels:
+
+    # mkdir /moldy
+    # mv /tmp /moldy/_
+    # ln -s /smack/tmp /tmp
+
+For each label users are going to use:
+
+    # mkdir /moldy/label
+    # chmod <appropriate-value> /moldy/label
+    # attr -S -s SMACK64 -V "label" /moldy/label
+
+If you don't do anything special all users will get the floor ("_")
+label when they log in. If you do want to log in via the hacked ssh
+at other labels use the attr command to set the smack value on the
+home directory and it's contents.
+
+You can add access rules in /etc/smack/accesses. They take the form:
+
+    subjectlabel objectlabel access
+
+access is a combination of the letters rwxa which specify the
+kind of access permitted a subject with subjectlabel on an
+object with objectlabel. If there is no rule no access is allowed.
+
+A process can see the smack label it is running with by
+reading /proc/self/attr/current. A privileged process can
+set the process smack by writing there.
+
+
diff -puN security/Kconfig~smack-simplified-mandatory-access-control-kernel security/Kconfig
--- a/security/Kconfig~smack-simplified-mandatory-access-control-kernel
+++ a/security/Kconfig
@@ -104,6 +104,7 @@ config SECURITY_ROOTPLUG
 	  If you are unsure how to answer this question, answer N.
 
 source security/selinux/Kconfig
+source security/smack/Kconfig
 
 endmenu
 
diff -puN security/Makefile~smack-simplified-mandatory-access-control-kernel security/Makefile
--- a/security/Makefile~smack-simplified-mandatory-access-control-kernel
+++ a/security/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_KEYS)			+= keys/
 subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
+subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 
 # if we don't select a security model, use the default capabilities
 ifneq ($(CONFIG_SECURITY),y)
@@ -14,5 +15,6 @@ endif
 obj-$(CONFIG_SECURITY)			+= security.o dummy.o inode.o
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
+obj-$(CONFIG_SECURITY_SMACK)		+= commoncap.o smack/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
diff -puN /dev/null security/smack/Kconfig
--- /dev/null
+++ a/security/smack/Kconfig
@@ -0,0 +1,10 @@
+config SECURITY_SMACK
+	bool "Simplified Mandatory Access Control Kernel Support"
+	depends on NETLABEL && SECURITY_NETWORK
+	default n
+	help
+	  This selects the Simplified Mandatory Access Control Kernel.
+	  Smack is useful for sensitivity, integrity, and a variety
+	  of other mandatory security schemes.
+	  If you are unsure how to answer this question, answer N.
+
diff -puN /dev/null security/smack/Makefile
--- /dev/null
+++ a/security/smack/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for the SMACK LSM
+#
+
+obj-$(CONFIG_SECURITY_SMACK) := smack.o
+
+smack-y := smack_lsm.o smack_access.o smackfs.o
+
+EXTRA_CFLAGS += -Inet/netlabel
diff -puN /dev/null security/smack/smack_access.c
--- /dev/null
+++ a/security/smack/smack_access.c
@@ -0,0 +1,345 @@
+/*
+ * Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation, version 2.
+ *
+ * Author:
+ *      Casey Schaufler <casey@schaufler-ca.com>
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include "smack.h"
+
+struct smack_known smack_known_unset = {
+	.smk_next	= NULL,
+	.smk_known	= "UNSET",
+	.smk_secid	= 1,
+	.smk_cipso	= NULL,
+};
+
+struct smack_known smack_known_huh = {
+	.smk_next	= &smack_known_unset,
+	.smk_known	= "?",
+	.smk_secid	= 2,
+	.smk_cipso	= NULL,
+};
+
+struct smack_known smack_known_hat = {
+	.smk_next	= &smack_known_huh,
+	.smk_known	= "^",
+	.smk_secid	= 3,
+	.smk_cipso	= NULL,
+};
+
+struct smack_known smack_known_star = {
+	.smk_next	= &smack_known_hat,
+	.smk_known	= "*",
+	.smk_secid	= 4,
+	.smk_cipso	= NULL,
+};
+
+struct smack_known smack_known_floor = {
+	.smk_next	= &smack_known_star,
+	.smk_known	= "_",
+	.smk_secid	= 5,
+	.smk_cipso	= NULL,
+};
+
+struct smack_known smack_known_invalid = {
+	.smk_next	= &smack_known_floor,
+	.smk_known	= "",
+	.smk_secid	= 6,
+	.smk_cipso	= NULL,
+};
+
+struct smack_known *smack_known = &smack_known_invalid;
+/*
+ * The initial value needs to be bigger than any of the
+ * known values above.
+ */
+static u32 smack_next_secid = 10;
+
+extern struct smk_list_entry *smack_list;
+
+/**
+ * smk_access - determine if a subject has a specific access to an object
+ * @subject_label: a pointer to the subject's Smack label
+ * @object_label: a pointer to the object's Smack label
+ * @request: the access requested, in "MAY" format
+ *
+ * This function looks up the subject/object pair in the
+ * access rule list and returns 0 if the access is permitted,
+ * non zero otherwise.
+ *
+ * Even though Smack labels are usually shared on smack_list
+ * labels that come in off the network can't be imported
+ * and added to the list for locking reasons.
+ *
+ * Therefore, it is necessary to check the contents of the labels,
+ * not just the pointer values. Of course, in most cases the labels
+ * will be on the list, so checking the pointers may be a worthwhile
+ * optimization.
+ */
+int smk_access(char *subject_label, char *object_label, int request)
+{
+	u32 may = MAY_NOT;
+	struct smk_list_entry *sp;
+	struct smack_rule *srp;
+
+	/*
+	 * Hardcoded comparisons.
+	 *
+	 * A star subject can't access any object.
+	 */
+	if (subject_label == smack_known_star.smk_known ||
+	    strcmp(subject_label, smack_known_star.smk_known) == 0)
+		return -EACCES;
+	/*
+	 * A star object can be accessed by any subject.
+	 */
+	if (object_label == smack_known_star.smk_known ||
+	    strcmp(object_label, smack_known_star.smk_known) == 0)
+		return 0;
+	/*
+	 * An object can be accessed in any way by a subject
+	 * with the same label.
+	 */
+	if (subject_label == object_label ||
+	    strcmp(subject_label, object_label) == 0)
+		return 0;
+	/*
+	 * A hat subject can read any object.
+	 * A floor object can be read by any subject.
+	 */
+	if ((request & MAY_ANYREAD) == request) {
+		if (object_label == smack_known_floor.smk_known ||
+		    strcmp(object_label, smack_known_floor.smk_known) == 0)
+			return 0;
+		if (subject_label == smack_known_hat.smk_known ||
+		    strcmp(subject_label, smack_known_hat.smk_known) == 0)
+			return 0;
+	}
+	/*
+	 * Beyond here an explicit relationship is required.
+	 * If the requested access is contained in the available
+	 * access (e.g. read is included in readwrite) it's
+	 * good.
+	 */
+	for (sp = smack_list; sp != NULL; sp = sp->smk_next) {
+		srp = &sp->smk_rule;
+
+		if (srp->smk_subject == subject_label ||
+		    strcmp(srp->smk_subject, subject_label) == 0) {
+			if (srp->smk_object == object_label ||
+			    strcmp(srp->smk_object, object_label) == 0) {
+				may = srp->smk_access;
+				break;
+			}
+		}
+	}
+	/*
+	 * This is a bit map operation.
+	 */
+	if ((request & may) == request)
+		return 0;
+
+	return -EACCES;
+}
+
+/**
+ * smk_curacc - determine if current has a specific access to an object
+ * @object_label: a pointer to the object's Smack label
+ * @request: the access requested, in "MAY" format
+ *
+ * This function checks the current subject label/object label pair
+ * in the access rule list and returns 0 if the access is permitted,
+ * non zero otherwise. It allows that current my have the capability
+ * to override the rules.
+ */
+int smk_curacc(char *obj_label, u32 mode)
+{
+	int rc;
+
+	rc = smk_access(current->security, obj_label, mode);
+	if (rc == 0)
+		return 0;
+
+	if (capable(CAP_MAC_OVERRIDE))
+		return 0;
+
+	return rc;
+}
+
+extern struct mutex smack_known_lock;
+
+/**
+ * smk_import_entry - import a label, return the list entry
+ * @string: a text string that might be a Smack label
+ * @len: the maximum size, or zero if it is NULL terminated.
+ *
+ * Returns a pointer to the entry in the label list that
+ * matches the passed string, adding it if necessary.
+ */
+struct smack_known *smk_import_entry(const char *string, int len)
+{
+	struct smack_known *skp;
+	char smack[SMK_LABELLEN];
+	int found;
+	int i;
+
+	if (len <= 0 || len > SMK_MAXLEN)
+		len = SMK_MAXLEN;
+
+	for (i = 0, found = 0; i < SMK_LABELLEN; i++) {
+		if (found)
+			smack[i] = '\0';
+		else if (i >= len || string[i] > '~' || string[i] <= ' ') {
+			smack[i] = '\0';
+			found = 1;
+		}
+		else
+			smack[i] = string[i];
+	}
+
+	if (smack[0] == '\0')
+		return NULL;
+
+	mutex_lock(&smack_known_lock);
+
+	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
+		if (skp->smk_known == smack)
+			break;
+
+	if (skp == NULL) {
+		skp = kzalloc(sizeof(struct smack_known), GFP_KERNEL);
+		if (skp != NULL) {
+			skp->smk_next = smack_known;
+			strncpy(skp->smk_known, smack, SMK_MAXLEN);
+			skp->smk_secid = smack_next_secid++;
+			skp->smk_cipso = NULL;
+			spin_lock_init(&skp->smk_cipsolock);
+			smack_known = skp;
+		}
+	}
+
+	mutex_unlock(&smack_known_lock);
+
+	return skp;
+}
+
+/**
+ * smk_import - import a smack label
+ * @string: a text string that might be a Smack label
+ * @len: the maximum size, or zero if it is NULL terminated.
+ *
+ * Returns a pointer to the label in the label list that
+ * matches the passed string, adding it if necessary.
+ */
+char *smk_import(const char *string, int len)
+{
+	struct smack_known *skp;
+
+	skp = smk_import_entry(string, len);
+	if (skp == NULL)
+		return NULL;
+	return skp->smk_known;
+}
+
+/**
+ * smack_from_secid - find the Smack label associated with a secid
+ * @secid: an integer that might be associated with a Smack label
+ *
+ * Returns a pointer to the appropraite Smack label if there is one,
+ * otherwise a pointer to the invalid Smack label.
+ */
+char *smack_from_secid(const u32 secid)
+{
+	struct smack_known *skp;
+
+	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
+		if (skp->smk_secid == secid)
+			return skp->smk_known;
+
+	/*
+	 * If we got this far someone asked for the translation
+	 * of a secid that is not on the list.
+	 */
+	return smack_known_invalid.smk_known;
+}
+
+u32 smack_to_secid(const char *smack)
+{
+	struct smack_known *skp;
+
+	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
+		if (skp->smk_known == smack)
+			return skp->smk_secid;
+	return 0;
+}
+
+/**
+ * smack_from_cipso - find the Smack label associated with a CIPSO option
+ * @level: Bell & LaPadula level from the network
+ * @catset: Bell & LaPadula categories from the network
+ * @result: where to put the Smack value
+ *
+ * This is a simple lookup in the label table.
+ *
+ * This is an odd duck as far as smack handling goes in that
+ * it sends back a copy of the smack label rather than a pointer
+ * to the master list. This is done because it is possible for
+ * a foreign host to send a smack label that is new to this
+ * machine and hence not on the list. That would not be an
+ * issue except that adding an entry to the master list can't
+ * be done at that point.
+ */
+void smack_from_cipso(u32 level, char *catset, char *result)
+{
+	struct smack_known *kp;
+	char *final = NULL;
+
+	for (kp = smack_known; final == NULL && kp != NULL; kp = kp->smk_next) {
+		if (kp->smk_cipso == NULL)
+			continue;
+
+		spin_lock_bh(&kp->smk_cipsolock);
+
+		if (kp->smk_cipso->smk_level == level &&
+		    memcmp(kp->smk_cipso->smk_catset,catset,SMK_LABELLEN) == 0)
+			final = kp->smk_known;
+
+		spin_unlock_bh(&kp->smk_cipsolock);
+	}
+	if (final == NULL)
+		final = smack_known_huh.smk_known;
+	strncpy(result, final, SMK_MAXLEN);
+	return;
+}
+
+/**
+ * smack_to_cipso - find the CIPSO option to go with a Smack label
+ * @smack: a pointer to the smack label in question
+ * @cp: where to put the result
+ *
+ * Returns zero if a value is available, non-zero otherwise.
+ */
+int smack_to_cipso(const char *smack, struct smack_cipso *cp)
+{
+        struct smack_known *kp;
+
+	for (kp = smack_known; kp != NULL; kp = kp->smk_next)
+		if (kp->smk_known == smack ||
+		    strcmp(kp->smk_known, smack) == 0)
+			break;
+
+	if (kp == NULL || kp->smk_cipso == NULL)
+		return -ENOENT;
+
+	memcpy(cp, kp->smk_cipso, sizeof(struct smack_cipso));
+	return 0;
+}
diff -puN /dev/null security/smack/smackfs.c
--- /dev/null
+++ a/security/smack/smackfs.c
@@ -0,0 +1,1201 @@
+/*
+ * Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *  	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation, version 2.
+ *
+ * Author:
+ * 	Casey Schaufler <casey@schaufler-ca.com>
+ *
+ * Special thanks to the authors of selinuxfs.
+ *
+ *	Karl MacMillan <kmacmillan@tresys.com>
+ *	James Morris <jmorris@redhat.com>
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/vmalloc.h>
+#include <linux/security.h>
+#include <linux/mutex.h>
+#include <net/netlabel.h>
+/*
+ * This include could get changed when the internal
+ * netlabel interface for initializing a netlabel domain
+ * has been worked out.
+ */
+#include "netlabel_domainhash.h"
+#include <net/cipso_ipv4.h>
+#include "smack.h"
+
+extern struct mutex smack_list_lock;
+extern struct smack_known smack_known_floor;
+extern struct smack_known smack_known_star;
+extern struct smack_known *smack_known;
+
+/*
+ * smackfs pseudo filesystem.
+ */
+
+enum smk_inos {
+	SMK_ROOT_INO	= 2,
+	SMK_LOAD	= 3,	/* load policy */
+	SMK_LINKS	= 4,	/* symlinks */
+	SMK_CIPSO	= 5,	/* load label -> CIPSO mapping */
+	SMK_DOI		= 6,	/* CIPSO DOI */
+	SMK_DIRECT	= 7,	/* CIPSO level indicating direct label */
+	SMK_AMBIENT	= 8,	/* internet ambient label */
+	SMK_NLTYPE	= 9,	/* label scheme to use by default */
+	SMK_TMP		= 100,	/* MUST BE LAST! /smack/tmp */
+};
+
+/*
+ * This is the "ambient" label for network traffic.
+ * If it isn't somehow marked, use this.
+ * It can be reset via smackfs/ambient
+ */
+char *smack_net_ambient = smack_known_floor.smk_known;
+
+/*
+ * This is the default packet marking scheme for network traffic.
+ * It can be reset via smackfs/nltype
+ */
+int smack_net_nltype = NETLBL_NLTYPE_CIPSOV4;
+
+/*
+ * This is the level in a CIPSO header that indicates a
+ * smack label is contained directly in the category set.
+ * It can be reset via smackfs/direct
+ */
+int smack_cipso_direct = SMACK_CIPSO_DIRECT_DEFAULT;
+
+static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
+static int smack_list_count;
+struct smk_list_entry *smack_list;
+
+/*
+ * 'ssssssss oooooooo mmmm\n\0'
+ */
+#define SMACK_RULE_LINE_SIZE (2 * SMK_MAXLEN + 6)
+
+/**
+ * smk_read_load - read() for /smack/load
+ * @filp: file pointer, not actually used
+ * @buf: where to put the result
+ * @count: maximum to send along
+ * @ppos: where to start
+ *
+ * Returns number of bytes read or error code, as appropriate
+ */
+static ssize_t smk_read_load(struct file *filp, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	ssize_t bytes;
+	struct smk_list_entry *slp = smack_list;
+	struct smack_rule *srp;
+	char *result;
+	char *cp;
+	int realbytes = 0;
+
+	bytes = SMACK_RULE_LINE_SIZE * smack_list_count;
+	if (bytes == 0)
+		return 0;
+
+	result = kzalloc(bytes, GFP_KERNEL);
+	if (result == NULL)
+		return -ENOMEM;
+
+	for (cp = result; slp != NULL; slp = slp->smk_next) {
+		srp = &slp->smk_rule;
+		sprintf(cp, "%-8s %-8s",
+			(char *)srp->smk_subject, (char *)srp->smk_object);
+		cp += strlen(cp);
+		if (srp->smk_access != 0)
+			*cp++ = ' ';
+		if ((srp->smk_access & MAY_READ) != 0)
+			*cp++ = 'r';
+		if ((srp->smk_access & MAY_WRITE) != 0)
+			*cp++ = 'w';
+		if ((srp->smk_access & MAY_EXEC) != 0)
+			*cp++ = 'x';
+		if ((srp->smk_access & MAY_APPEND) != 0)
+			*cp++ = 'a';
+		*cp++ = '\n';
+	}
+	*cp++ = '\0';
+	realbytes = strlen(result);
+
+	bytes = simple_read_from_buffer(buf, count, ppos, result, realbytes);
+
+	kfree(result);
+
+	return bytes;
+}
+
+/**
+ * smk_set_access - add a rule to the rule list
+ * @srp: the new rule to add
+ *
+ * Looks through the current subject/object/access list for
+ * the subject/object pair and replaces the access that was
+ * there. If the pair isn't found add it with the specified
+ * access.
+ */
+static void smk_set_access(struct smack_rule *srp)
+{
+	struct smk_list_entry *sp;
+	struct smk_list_entry *newp;
+
+	mutex_lock(&smack_list_lock);
+
+	for (sp = smack_list; sp != NULL; sp = sp->smk_next)
+		if (sp->smk_rule.smk_subject == srp->smk_subject &&
+		    sp->smk_rule.smk_object == srp->smk_object) {
+			sp->smk_rule.smk_access = srp->smk_access;
+			break;
+		}
+
+	if (sp == NULL) {
+		newp = kzalloc(sizeof(struct smk_list_entry), GFP_KERNEL);
+		newp->smk_rule = *srp;
+		newp->smk_next = smack_list;
+		smack_list = newp;
+		smack_list_count++;
+	}
+
+	mutex_unlock(&smack_list_lock);
+
+	return;
+}
+
+
+/**
+ * smk_write_load - write() for /smack/load
+ * @filp: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Returns number of bytes written or error code, as appropriate
+ */
+static ssize_t smk_write_load(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	struct smack_rule rule;
+	ssize_t rc = count;
+	char *data = NULL;
+	char subjectstr[SMK_LABELLEN];
+	char objectstr[SMK_LABELLEN];
+	char modestr[8];
+	char *cp;
+
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+	/*
+	 * No partial writes.
+	 */
+	if (*ppos != 0)
+		return -EINVAL;
+
+	/*
+	 * 80 characters per line ought to be enough.
+	 */
+	if (count > SMACK_LIST_MAX * 80)
+		return -ENOMEM;
+
+	data = kzalloc(count + 1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, count) != 0) {
+		kfree(data);
+		return -EFAULT;
+	}
+
+	*(data + count) = '\0';
+
+	for (cp = data - 1; cp != NULL; cp = strchr(cp + 1, '\n')) {
+		if (*++cp == '\0')
+			break;
+		if (sscanf(cp, "%23s %23s %7s\n", subjectstr, objectstr,
+			   modestr) != 3) {
+			printk("%s:%d bad scan\n", __func__, __LINE__);
+			break;
+		}
+		rule.smk_subject = smk_import(subjectstr, 0);
+		if (rule.smk_subject == NULL)
+			break;
+		rule.smk_object = smk_import(objectstr, 0);
+		if (rule.smk_object == NULL)
+			break;
+		rule.smk_access = 0;
+		if (strpbrk(modestr, "rR") != NULL)
+			rule.smk_access |= MAY_READ;
+		if (strpbrk(modestr, "wW") != NULL)
+			rule.smk_access |= MAY_WRITE;
+		if (strpbrk(modestr, "xX") != NULL)
+			rule.smk_access |= MAY_EXEC;
+		if (strpbrk(modestr, "aA") != NULL)
+			rule.smk_access |= MAY_APPEND;
+		smk_set_access(&rule);
+		printk("%s:%d rule %s %s 0x%x\n", __func__, __LINE__,
+			(char *)rule.smk_subject, (char *)rule.smk_object,
+			rule.smk_access);
+	}
+
+	kfree(data);
+	return rc;
+}
+
+static const struct file_operations smk_load_ops = {
+	.read		= smk_read_load,
+	.write		= smk_write_load,
+};
+
+/**
+ * smk_digit - return a pointer to the next digit
+ * @cp: where to start
+ *
+ * Returns a pointer to the next digit in the string, or NULL
+ */
+static inline char *smk_digit(const char *cp)
+{
+	return strpbrk(cp, "0123456789");
+}
+
+static unsigned int smk_cipso_written;
+
+/**
+ * smk_cipso_doi - initialize the CIPSO domain
+ *
+ * This code reaches too deeply into netlabel internals
+ * for comfort, however there is no netlabel KAPI that
+ * allows for kernel based initialization of a CIPSO DOI.
+ * Until Paul and Casey can work out an appropriate
+ * interface Smack will do it this way.
+ */
+void smk_cipso_doi(void)
+{
+	int rc;
+	struct cipso_v4_doi *doip;
+	struct netlbl_dom_map *ndmp;
+	struct netlbl_audit audit_info;
+
+	doip = kmalloc(sizeof(struct cipso_v4_doi), GFP_KERNEL);
+	if (doip == NULL)
+		panic("smack:  Failed to initialize cipso DOI.\n");
+	doip->map.std = NULL;
+
+	ndmp = kmalloc(sizeof(struct netlbl_dom_map), GFP_KERNEL);
+	if (ndmp == NULL)
+		panic("smack:  Failed to initialize cipso ndmp.\n");
+
+	doip->doi = smk_cipso_doi_value;
+	doip->type = CIPSO_V4_MAP_PASS;
+	doip->tags[0] = CIPSO_V4_TAG_RBITMAP;
+	for (rc = 1; rc < CIPSO_V4_TAG_MAXCNT; rc++)
+		doip->tags[rc] = CIPSO_V4_TAG_INVALID;
+
+	rc = cipso_v4_doi_add(doip);
+	if (rc != 0)
+		printk("%s:%d add doi rc = %d\n", __func__, __LINE__, rc);
+
+	ndmp->domain = NULL;
+	ndmp->type = NETLBL_NLTYPE_CIPSOV4;
+	ndmp->type_def.cipsov4 = doip;
+
+	rc = netlbl_domhsh_remove_default(&audit_info);
+	if (rc != 0)
+		printk("%s:%d remove rc = %d\n", __func__, __LINE__, rc);
+
+	rc = netlbl_domhsh_add_default(ndmp, &audit_info);
+	if (rc != 0)
+		printk("%s:%d add rc = %d\n", __func__, __LINE__, rc);
+}
+
+/**
+ * smk_read_cipso - read() for /smack/cipso
+ * @filp: file pointer, not actually used
+ * @buf: where to put the result
+ * @count: maximum to send along
+ * @ppos: where to start
+ *
+ * Returns number of bytes read or error code, as appropriate
+ *
+ * label level[/cat[,cat]]
+ */
+static ssize_t smk_read_cipso(struct file *filp, char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	struct smack_known *skp;
+	struct smack_cipso *scp;
+	ssize_t bytes;
+	char sep;
+	char *result;
+	char *cp;
+	char *cbp;
+	int realbytes = 0;
+	int cat = -1;
+	int i;
+	unsigned char m;
+
+	if (smk_cipso_written == 0)
+		return 0;
+
+	result = kzalloc(smk_cipso_written, GFP_KERNEL);
+	if (result == NULL)
+		return -ENOMEM;
+	cp = result;
+
+	for (skp = smack_known; skp != NULL; skp = skp->smk_next) {
+		if (skp->smk_cipso == NULL)
+			continue;
+		scp = skp->smk_cipso;
+		cp += sprintf(cp, "%-8s %3d",
+			(char *)&skp->smk_known, scp->smk_level);
+		cat = 1;
+		sep = '/';
+		cbp = scp->smk_catset;
+		for (i = 0; i < SMK_LABELLEN; i++) {
+			for (m = 0x80; m != 0; m >>= 1) {
+				if ((m & cbp[i]) != 0) {
+					cp += sprintf(cp, "%c%d", sep, cat);
+					sep = ',';
+				}
+				cat++;
+			}
+		}
+		*cp++ = '\n';
+	}
+	*cp++ = '\0';
+	realbytes = strlen(result);
+
+	bytes = simple_read_from_buffer(buf, count, ppos, result, realbytes);
+
+	kfree(result);
+
+	return bytes;
+}
+
+/**
+ * smk_write_cipso - write() for /smack/cipso
+ * @filp: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Returns number of bytes written or error code, as appropriate
+ */
+static ssize_t smk_write_cipso(struct file *file, const char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	struct smack_known *skp;
+	struct smack_cipso *scp;
+	char *mapsmack;
+	char mapcatset[SMK_LABELLEN];
+	int maplevel;
+	ssize_t rc = count;
+	char *data = NULL;
+	char *cp;
+	char *eolp;
+	char *linep;
+	int cat;
+	int i;
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+	/*
+	 * No partial writes.
+	 */
+	if (*ppos != 0)
+		return -EINVAL;
+	/*
+	 * 80 characters per line ought to be enough.
+	 */
+	if (count > SMACK_LIST_MAX * 80)
+		return -ENOMEM;
+
+	data = kzalloc(count + 1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, count) != 0) {
+		kfree(data);
+		return -EFAULT;
+	}
+
+	*(data + count) = '\0';
+	smk_cipso_written += count;
+
+	for (eolp = strchr(data, '\n'), linep = data;
+		eolp != NULL && rc >= 0;
+		linep = eolp + 1, eolp = strchr(linep, '\n')) {
+
+		if (eolp == linep)
+			continue;
+		*eolp = '\0';
+		memset(mapcatset, '\0', SMK_LABELLEN);
+
+		skp = smk_import_entry(linep, 0);
+		if (skp == NULL)
+			continue;
+		mapsmack = skp->smk_known;
+
+		cp = smk_digit(linep + strlen((char *)mapsmack));
+		if (cp == NULL)
+			continue;
+
+		i = sscanf(cp, "%d", &maplevel);
+		if (i != 1)
+			continue;
+
+		cp = strchr(cp, '/');
+		if (cp != NULL) {
+			cp = smk_digit(cp);
+			if (cp == NULL)
+				continue;
+
+			do {
+				i = sscanf(cp, "%d", &cat);
+				if (i != 1)
+					break;
+				if (cat > SMACK_CIPSO_MAXCAT) {
+					i = 0;
+					break;
+				}
+				smack_catset_bit(cat, mapcatset);
+
+				cp = strchr(cp, ',');
+				if (cp != NULL)
+					cp = smk_digit(cp);
+			} while (cp != NULL);
+		}
+
+		if (i != 1)
+			continue;
+
+
+		if (skp->smk_cipso == NULL) {
+			scp = kzalloc(sizeof(struct smack_cipso), GFP_KERNEL);
+			if (scp == NULL) {
+				rc = -ENOMEM;
+				break;
+			}
+		} else
+			scp = NULL;
+
+		spin_lock_bh(&skp->smk_cipsolock);
+		if (skp->smk_cipso == NULL) {
+			skp->smk_cipso = scp;
+			scp = NULL;
+		}
+		skp->smk_cipso->smk_level = maplevel;
+		memcpy(skp->smk_cipso->smk_catset, mapcatset, SMK_MAXLEN);
+		spin_unlock_bh(&skp->smk_cipsolock);
+
+		/*
+		 * The only way this could be true is for there
+		 * to have been two attempts to update the cipso
+		 * list at the same time. One of the two will have
+		 * won cleanly, but there remains cleanup to do.
+		 */
+		if (scp != NULL) {
+			printk(KERN_WARNING "%s: CIPSO collision for \"%s\"\n",
+				__func__, skp->smk_known);
+			kfree(scp);
+		}
+		/*
+		 * Add this to ensure that there are
+		 * enough bytes for the regurgitation
+		 */
+		smk_cipso_written += SMK_LABELLEN;
+	}
+
+	kfree(data);
+	return rc;
+}
+
+static const struct file_operations smk_cipso_ops = {
+	.read		= smk_read_cipso,
+	.write		= smk_write_cipso,
+};
+
+/**
+ * smk_read_doi - read() for /smack/doi
+ * @filp: file pointer, not actually used
+ * @buf: where to put the result
+ * @count: maximum to send along
+ * @ppos: where to start
+ *
+ * Returns number of bytes read or error code, as appropriate
+ */
+static ssize_t smk_read_doi(struct file *filp, char __user *buf,
+			        size_t count, loff_t *ppos)
+{
+	char temp[80];
+	ssize_t rc;
+
+	if (*ppos != 0)
+		return 0;
+
+	sprintf(temp, "%d", smk_cipso_doi_value);
+	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
+
+	return rc;
+}
+
+/**
+ * smk_write_doi - write() for /smack/doi
+ * @filp: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Returns number of bytes written or error code, as appropriate
+ */
+static ssize_t smk_write_doi(struct file *file, const char __user *buf,
+			         size_t count, loff_t *ppos)
+{
+	char temp[80];
+	int i;
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	if (count > sizeof(temp))
+		return -EINVAL;
+
+	if (copy_from_user(temp, buf, count) != 0)
+		return -EFAULT;
+
+	if (sscanf(temp, "%d", &i) != 1)
+		return -EINVAL;
+
+	smk_cipso_doi_value = i;
+
+	return count;
+}
+
+static const struct file_operations smk_doi_ops = {
+	.read		= smk_read_doi,
+	.write		= smk_write_doi,
+};
+
+/**
+ * smk_read_direct - read() for /smack/direct
+ * @filp: file pointer, not actually used
+ * @buf: where to put the result
+ * @count: maximum to send along
+ * @ppos: where to start
+ *
+ * Returns number of bytes read or error code, as appropriate
+ */
+static ssize_t smk_read_direct(struct file *filp, char __user *buf,
+			        size_t count, loff_t *ppos)
+{
+	char temp[80];
+	ssize_t rc;
+
+	if (*ppos != 0)
+		return 0;
+
+	sprintf(temp, "%d", smack_cipso_direct);
+	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
+
+	return rc;
+}
+
+/**
+ * smk_write_direct - write() for /smack/direct
+ * @filp: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Returns number of bytes written or error code, as appropriate
+ */
+static ssize_t smk_write_direct(struct file *file, const char __user *buf,
+			         size_t count, loff_t *ppos)
+{
+	char temp[80];
+	int i;
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	if (count > sizeof(temp))
+		return -EINVAL;
+
+	if (copy_from_user(temp, buf, count) != 0)
+		return -EFAULT;
+
+	if (sscanf(temp, "%d", &i) != 1)
+		return -EINVAL;
+
+	smack_cipso_direct = i;
+
+	return count;
+}
+
+static const struct file_operations smk_direct_ops = {
+	.read		= smk_read_direct,
+	.write		= smk_write_direct,
+};
+
+/**
+ * smk_read_ambient - read() for /smack/ambient
+ * @filp: file pointer, not actually used
+ * @buf: where to put the result
+ * @count: maximum to send along
+ * @ppos: where to start
+ *
+ * Returns number of bytes read or error code, as appropriate
+ */
+static ssize_t smk_read_ambient(struct file *filp, char __user *buf,
+			        size_t count, loff_t *ppos)
+{
+	ssize_t rc;
+	int asize = strlen(smack_net_ambient) + 1;
+
+	if (count < asize)
+		return -EINVAL;
+
+	if (*ppos != 0)
+		return 0;
+
+	rc = simple_read_from_buffer(buf,count,ppos,smack_net_ambient,asize);
+
+	return rc;
+}
+
+/**
+ * smk_write_ambient - write() for /smack/ambient
+ * @filp: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Returns number of bytes written or error code, as appropriate
+ */
+static ssize_t smk_write_ambient(struct file *file, const char __user *buf,
+			         size_t count, loff_t *ppos)
+{
+	char in[SMK_LABELLEN];
+	char *smack;
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	if (count >= SMK_LABELLEN)
+		return -EINVAL;
+
+	if (copy_from_user(in, buf, count) != 0)
+		return -EFAULT;
+
+	smack = smk_import(in, count);
+	if (smack == NULL)
+		return -EINVAL;
+	/*
+	 * Better check to be sure this is OK.
+	 */
+	smack_net_ambient = smack;
+
+	return count;
+}
+
+static const struct file_operations smk_ambient_ops = {
+	.read		= smk_read_ambient,
+	.write		= smk_write_ambient,
+};
+
+struct option_names {
+	int	o_number;
+	char	*o_name;
+	char	*o_alias;
+};
+
+static struct option_names netlbl_choices[] = {
+	{ NETLBL_NLTYPE_RIPSO,
+		NETLBL_NLTYPE_RIPSO_NAME,	"ripso" },
+	{ NETLBL_NLTYPE_CIPSOV4,
+		NETLBL_NLTYPE_CIPSOV4_NAME,	"cipsov4" },
+	{ NETLBL_NLTYPE_CIPSOV4,
+		NETLBL_NLTYPE_CIPSOV4_NAME,	"cipso" },
+	{ NETLBL_NLTYPE_CIPSOV6,
+		NETLBL_NLTYPE_CIPSOV6_NAME,	"cipsov6" },
+	{ NETLBL_NLTYPE_UNLABELED,
+		NETLBL_NLTYPE_UNLABELED_NAME,	"unlabeled" },
+};
+
+/**
+ * smk_read_nltype - read() for /smack/nltype
+ * @filp: file pointer, not actually used
+ * @buf: where to put the result
+ * @count: maximum to send along
+ * @ppos: where to start
+ *
+ * Returns number of bytes read or error code, as appropriate
+ */
+static ssize_t smk_read_nltype(struct file *filp, char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	char bound[40];
+	ssize_t rc;
+	int i;
+
+	if (count < SMK_LABELLEN)
+		return -EINVAL;
+
+	if (*ppos != 0)
+		return 0;
+
+	sprintf(bound, "unknown");
+
+	for (i = 0; i < ARRAY_SIZE(netlbl_choices); i++)
+		if (smack_net_nltype == netlbl_choices[i].o_number) {
+			sprintf(bound, "%s", netlbl_choices[i].o_name);
+			break;
+		}
+
+	rc = simple_read_from_buffer(buf, count, ppos, bound, strlen(bound));
+
+	return rc;
+}
+
+/**
+ * smk_write_nltype - write() for /smack/nltype
+ * @filp: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Returns number of bytes written or error code, as appropriate
+ */
+static ssize_t smk_write_nltype(struct file *file, const char __user *buf,
+			        size_t count, loff_t *ppos)
+{
+	char bound[40];
+	char *cp;
+	int i;
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	if (count >= 40)
+		return -EINVAL;
+
+	if (copy_from_user(bound, buf, count) != 0)
+		return -EFAULT;
+
+	bound[count] = '\0';
+	cp = strchr(bound, ' ');
+	if (cp != NULL)
+		*cp = '\0';
+	cp = strchr(bound, '\n');
+	if (cp != NULL)
+		*cp = '\0';
+
+	for (i = 0; i < ARRAY_SIZE(netlbl_choices); i++)
+		if (strcmp(bound, netlbl_choices[i].o_name) == 0 ||
+		    strcmp(bound, netlbl_choices[i].o_alias) == 0) {
+			smack_net_nltype = netlbl_choices[i].o_number;
+			return count;
+		}
+	/*
+	 * Not a valid choice.
+	 */
+	return -EINVAL;
+}
+
+static const struct file_operations smk_nltype_ops = {
+	.read		= smk_read_nltype,
+	.write		= smk_write_nltype,
+};
+
+/*
+ * mapping for symlinks
+ */
+#define SMK_TMPPATH_SIZE        1024
+#define SMK_TMPPATH_ROOT        "/moldy/"
+
+struct smk_link {
+	struct smk_link	*sl_next;
+	int		sl_inum;
+	char		sl_name[SMK_TMPPATH_SIZE];
+	char		sl_target[SMK_TMPPATH_SIZE];
+};
+
+static struct super_block *smk_sb = NULL;
+static struct smk_link *smk_links = NULL;
+static int smk_links_count = 0;
+
+/**
+ * smackfs_follow_link - follow a smackfs symlink
+ * @dentry: name cache entry
+ * @nd: name entry
+ *
+ * A symlink on smackfs has unusual semantics.
+ *
+ * The Smack value of the task is appended to the link string.
+ * Thus, if a task labeled "Gentoo" does chdir("/smack/tmp")
+ * it will use "/moldy/Gentoo".
+ *
+ * The expected usage is the /tmp is a symlink to /smack/tmp
+ * which is itself a symlink to /moldy. /moldy should have a
+ * directory for each label in use to accomodate the value
+ * appended on the redirection.
+ *
+ * An interesting addition would be a file system that automatically
+ * creates directories as needed, at the appropriate label.
+ */
+static void *smackfs_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	char *sp = current->security;
+	char *cp;
+	int inum = dentry->d_inode->i_ino;
+	struct smk_link *slp;
+
+	for (slp = smk_links; slp != NULL; slp = slp->sl_next)
+		if (slp->sl_inum == inum)
+			break;
+
+	if (slp == NULL) {
+		printk("%s:%d failed\n", __func__, __LINE__);
+		return NULL;
+	}
+	cp = kzalloc(SMK_TMPPATH_SIZE, GFP_KERNEL);
+	if (cp == NULL)
+		return NULL;
+
+	strcpy(cp, slp->sl_target);
+	strcat(cp, sp);
+	nd_set_link(nd, cp);
+	/*
+	 * Unlike the readlink below, hang on to the memory allocated
+	 * because nd_set_link passes it along.
+	 */
+	return NULL;
+}
+
+/**
+ * smackfs_readlink - read a smackfs symlink
+ * @dentry: name cache entry
+ * @buffer: where the result goes
+ * @buflen: buffer size
+ *
+ * Returns 0 on success, an error code otherwise
+ *
+ * Supports the same semantics as the follow code.
+ */
+static int smackfs_readlink(struct dentry *dentry, char __user *buffer,
+			    int buflen)
+{
+	char *csp = current->security;
+	char *cp;
+	int len;
+	int inum = dentry->d_inode->i_ino;
+	struct smk_link *slp;
+
+	for (slp = smk_links; slp != NULL; slp = slp->sl_next)
+		if (slp->sl_inum == inum)
+			break;
+
+	if (slp == NULL) {
+		printk("%s:%d failed\n", __func__, __LINE__);
+		return -EACCES;
+	}
+
+	cp = kzalloc(SMK_TMPPATH_SIZE, GFP_KERNEL);
+	if (cp == NULL)
+		return -ENOMEM;
+
+	strcpy(cp, slp->sl_target);
+	strcat(cp, csp);
+	len = strlen(cp);
+	len = (len > buflen) ? buflen : len;
+
+	if (copy_to_user(buffer, cp, len) != 0)
+		len = -EFAULT;
+
+	kfree(cp);
+	return len;
+}
+
+/**
+ * smackfs_put_link - free a followed component
+ * @dentry: unused
+ * @nd: name entry
+ * @ptr: unused
+ *
+ * free the buffer used in following the link.
+ */
+static void smackfs_put_link(struct dentry *dentry, struct nameidata *nd, void *ptr)
+{
+	kfree(nd_get_link(nd));
+}
+
+static struct inode_operations smackfs_symlink_inode_operations = {
+	.readlink	= smackfs_readlink,
+	.follow_link	= smackfs_follow_link,
+	.put_link	= smackfs_put_link,
+};
+
+/**
+ * smk_add_symlink - follow a smackfs symlink
+ * @name: the name of the synlink
+ * @target: where it points to
+ *
+ * Add a smackfs symlink
+ */
+static void smk_add_symlink(char *name, char *target)
+{
+	static int inum = SMK_TMP;
+	struct inode *inode;
+	struct dentry *dentry;
+	struct smk_link *slp;
+
+	for (slp = smk_links; slp != NULL; slp = slp->sl_next) {
+		if (strcmp(slp->sl_name, name) != 0)
+			continue;
+		strcpy(slp->sl_target, target);
+		return;
+	}
+
+	slp = kzalloc(sizeof(struct smk_link), GFP_KERNEL);
+	if (slp == NULL)
+		return;
+
+	dentry = d_alloc_name(smk_sb->s_root, name);
+	if (dentry == NULL) {
+		printk("%s:%d link dentry failed\n", __func__, __LINE__);
+		return;
+	}
+
+	inode = new_inode(smk_sb);
+	if (inode == NULL) {
+		printk("%s:%d link inode failed\n", __func__, __LINE__);
+		return;
+	}
+
+	inode->i_mode = S_IFLNK | S_IRWXUGO;
+	inode->i_uid = 0;
+	inode->i_gid = 0;
+	inode->i_blocks = 0;
+	inode->i_atime = CURRENT_TIME;
+	inode->i_mtime = inode->i_atime;
+	inode->i_ctime = inode->i_atime;
+	inode->i_ino = inum++;
+	inode->i_op = &smackfs_symlink_inode_operations;
+	d_add(dentry, inode);
+
+	strcpy(slp->sl_name, name);
+	strcpy(slp->sl_target, target);
+	slp->sl_inum = inode->i_ino;
+	slp->sl_next = smk_links;
+	smk_links = slp;
+	smk_links_count++;
+
+	return;
+}
+
+/**
+ * smk_read_links - read() for /smack/links
+ * @filp: file pointer, not actually used
+ * @buf: where to put the result
+ * @count: maximum to send along
+ * @ppos: where to start
+ *
+ * Returns number of bytes read or error code, as appropriate
+ */
+static ssize_t smk_read_links(struct file *filp, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	ssize_t bytes = sizeof(struct smk_link) * smk_links_count;
+	struct smk_link *slp;
+	char *result;
+	char *cp;
+
+
+	result = kzalloc(bytes, GFP_KERNEL);
+	if (result == NULL)
+		return -ENOMEM;
+	*result = '\0';
+
+	for (slp = smk_links, cp = result; slp != NULL; slp = slp->sl_next)
+		cp += sprintf(cp, "%s %s\n", slp->sl_name, slp->sl_target);
+
+	bytes = simple_read_from_buffer(buf,count,ppos,result,strlen(result));
+
+	kfree(result);
+
+	return bytes;
+}
+
+/**
+ * smk_write_links - write() for /smack/links
+ * @filp: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Returns number of bytes written or error code, as appropriate
+ *
+ * This might be better done using "real" symlink creation.
+ */
+static ssize_t smk_write_links(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	ssize_t rc = count;
+	char *data;
+	char *cp;
+	char name[SMK_TMPPATH_SIZE];
+	char target[SMK_TMPPATH_SIZE];
+
+	/*
+	 * No partial writes.
+	 */
+	if (*ppos != 0)
+		return -EINVAL;
+	/*
+	 * 80 characters per line ought to be enough.
+	 */
+	if (count > SMACK_LIST_MAX * 80)
+		return -ENOMEM;
+
+	data = kzalloc(count + 1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, count) != 0) {
+		kfree(data);
+		return -EFAULT;
+	}
+
+	data[count] = '\0';
+
+	for (cp = data - 1; cp != NULL; cp = strchr(cp + 1, '\n')) {
+		if (*++cp == '\0')
+			break;
+		if (sscanf(cp, "%14s %30s\n", name, target) != 2) {
+			printk("%s:%d bad scan\n",
+				__func__, __LINE__);
+			break;
+		}
+		smk_add_symlink(name, target);
+		printk("%s:%d add %s -> %s\n",
+			__func__, __LINE__, name, target);
+	}
+
+	kfree(data);
+	return rc;
+}
+
+static const struct file_operations smk_links_ops = {
+	.read		= smk_read_links,
+	.write		= smk_write_links,
+};
+
+/**
+ * smk_fill_super - fill the /smackfs superblock
+ * @sb: the empty superblock
+ * @data: unused
+ * @silent: unused
+ *
+ * Fill in the well known entries for /smack and set up for
+ * symlinks
+ *
+ * Returns 0 on success, an error code on failure
+ */
+static int smk_fill_super(struct super_block *sb, void * data, int silent)
+{
+	int rc;
+	struct inode *root_inode;
+
+	static struct tree_descr smack_files[] = {
+		[SMK_LOAD]	= {"load", &smk_load_ops, S_IRUGO|S_IWUSR},
+		[SMK_LINKS]	= {"links", &smk_links_ops, S_IRUGO|S_IWUSR},
+		[SMK_CIPSO]	= {"cipso", &smk_cipso_ops, S_IRUGO|S_IWUSR},
+		[SMK_DOI]	= {"doi", &smk_doi_ops, S_IRUGO|S_IWUSR},
+		[SMK_DIRECT]	= {"direct", &smk_direct_ops, S_IRUGO|S_IWUSR},
+		[SMK_AMBIENT]	= {"ambient", &smk_ambient_ops,S_IRUGO|S_IWUSR},
+		[SMK_NLTYPE]	= {"nltype", &smk_nltype_ops, S_IRUGO|S_IWUSR},
+		/* last one */ {""}
+	};
+
+	/*
+	 * There will be only one smackfs. Casey says so.
+	 */
+	smk_sb = sb;
+
+	rc = simple_fill_super(sb, SMACK_MAGIC, smack_files);
+	if (rc != 0) {
+		printk(KERN_ERR "%s failed %d while creating inodes\n",
+			__func__, rc);
+		return rc;
+	}
+
+	root_inode = sb->s_root->d_inode;
+	root_inode->i_security = new_inode_smack(smack_known_floor.smk_known);
+
+	/*
+	 * Create a directory for /smack/tmp
+	 */
+	smk_add_symlink("tmp", SMK_TMPPATH_ROOT);
+
+	return 0;
+}
+
+/**
+ * smk_get_sb - get the smackfs superblock
+ * @fs_type: passed along without comment
+ * @flags: passed along without comment
+ * @dev_name: passed along without comment
+ * @data: passed along without comment
+ * @mnt: passed along without comment
+ *
+ * Just passes everything along.
+ *
+ * Returns what the lower level code does.
+ */
+static int smk_get_sb(struct file_system_type *fs_type,
+		      int flags, const char *dev_name, void *data,
+		      struct vfsmount *mnt)
+{
+	return get_sb_single(fs_type, flags, data, smk_fill_super, mnt);
+}
+
+static struct file_system_type smk_fs_type = {
+	.name		= "smackfs",
+	.get_sb		= smk_get_sb,
+	.kill_sb	= kill_litter_super,
+};
+
+static struct vfsmount *smackfs_mount;
+
+/**
+ * init_smk_fs - get the smackfs superblock
+ *
+ * register the smackfs
+ *
+ * Returns 0 unless the registration fails.
+ */
+static int __init init_smk_fs(void)
+{
+	int err;
+
+	err = register_filesystem(&smk_fs_type);
+	if (!err) {
+		smackfs_mount = kern_mount(&smk_fs_type);
+		if (IS_ERR(smackfs_mount)) {
+			printk(KERN_ERR "smackfs:  could not mount!\n");
+			err = PTR_ERR(smackfs_mount);
+			smackfs_mount = NULL;
+		}
+	}
+
+	return err;
+}
+
+__initcall(init_smk_fs);
diff -puN /dev/null security/smack/smack.h
--- /dev/null
+++ a/security/smack/smack.h
@@ -0,0 +1,207 @@
+/*
+ * Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation, version 2.
+ *
+ * Author:
+ *      Casey Schaufler <casey@schaufler-ca.com>
+ *
+ */
+
+#ifndef _SECURITY_SMACK_H
+#define _SECURITY_SMACK_H
+
+#include <linux/capability.h>
+#include <linux/spinlock.h>
+#include <net/netlabel.h>
+
+/*
+ * Why 23? CIPSO is constrained to 30, so a 32 byte buffer is
+ * bigger than can be used, and 24 is the next lower multiple
+ * of 8, and there are too many issues if there isn't space set
+ * aside for the terminating null byte.
+ */
+#define SMK_MAXLEN	23
+#define SMK_LABELLEN	(SMK_MAXLEN+1)
+
+struct superblock_smack {
+	char	*smk_root;
+	char	*smk_floor;
+	char	*smk_hat;
+	char	*smk_default;
+	int	smk_initialized;
+};
+
+struct socket_smack {
+	char	*smk_out;	/* outbound label */
+	char	*smk_in;	/* inbound label */
+	char	smk_packet[SMK_LABELLEN];
+	int	smk_depth;
+};
+
+/*
+ * Inode smack data
+ */
+struct inode_smack {
+	char		*smk_inode;	/* label of the fso */
+	struct mutex	smk_lock;	/* initialization lock */
+	int		smk_flags;	/* smack inode flags */
+};
+
+#define	SMK_INODE_INSTANT	0x01	/* inode is instantiated */
+
+/*
+ * A label access rule.
+ */
+struct smack_rule {
+	char	*smk_subject;
+	char	*smk_object;
+	int	smk_access;
+};
+
+/*
+ * An entry in the table of permitted label accesses.
+ */
+struct smk_list_entry {
+	struct smk_list_entry	*smk_next;
+	struct smack_rule	smk_rule;
+};
+
+/*
+ * An entry in the table mapping smack values to
+ * CIPSO level/category-set values.
+ */
+struct smack_cipso {
+	int	smk_level;
+	char	smk_catset[SMK_LABELLEN];
+};
+
+/*
+ * This is the repository for labels seen so that it is
+ * not necessary to keep allocating tiny chuncks of memory
+ * and so that they can be shared.
+ *
+ * Labels are never modified in place. Anytime a label
+ * is imported (e.g. xattrset on a file) the list is checked
+ * for it and it is added if it doesn't exist. The address
+ * is passed out in either case. Entries are added, but
+ * never deleted.
+ *
+ * Since labels are hanging around anyway it doesn't
+ * hurt to maintain a secid for those awkward situations
+ * where kernel components that ought to use LSM independent
+ * interfaces don't. The secid should go away when all of
+ * these components have been repaired.
+ *
+ * If there is a cipso value associated with the label it
+ * gets stored here, too. This will most likely be rare as
+ * the cipso direct mapping in used internally.
+ */
+struct smack_known {
+	struct smack_known	*smk_next;
+	char			smk_known[SMK_LABELLEN];
+	u32			smk_secid;
+	struct smack_cipso	*smk_cipso;
+	spinlock_t		smk_cipsolock;
+};
+
+/*
+ * Mount options
+ */
+#define SMK_FSDEFAULT	"smackfsdef="
+#define SMK_FSFLOOR	"smackfsfloor="
+#define SMK_FSHAT	"smackfshat="
+#define SMK_FSROOT	"smackfsroot="
+
+/*
+ * xattr names
+ */
+#define XATTR_SMACK_SUFFIX	"SMACK64"
+#define XATTR_SMACK_IPIN	"SMACK64IPIN"
+#define XATTR_SMACK_IPOUT	"SMACK64IPOUT"
+#define XATTR_SMACK_PACKET	"SMACK64PACKET"
+#define XATTR_NAME_SMACK	XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
+
+/*
+ * smackfs macic number
+ */
+#define SMACK_MAGIC	0x43415d53 /* "SMAC" */
+
+/*
+ * A limit on the number of entries in the lists
+ * makes some of the list administration easier.
+ */
+#define SMACK_LIST_MAX	10000
+
+/*
+ * CIPSO defaults.
+ */
+#define SMACK_CIPSO_DOI_DEFAULT		3	/* Historical */
+#define SMACK_CIPSO_DIRECT_DEFAULT	250	/* Arbitrary */
+#define SMACK_CIPSO_MAXCAT		63	/* Bigger gets harder */
+
+/*
+ * Just to make the common cases easier to deal with
+ */
+#define MAY_ANY		(MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
+#define MAY_ANYREAD	(MAY_READ | MAY_EXEC)
+#define MAY_ANYWRITE	(MAY_WRITE | MAY_APPEND)
+#define MAY_READWRITE	(MAY_READ | MAY_WRITE)
+#define MAY_NOT		0
+
+/*
+ * There are not enough CAP bits available to make this
+ * real, so Casey borrowed the capability that looks to
+ * him like it has the best balance of similarity amd
+ * low use.
+ */
+#define CAP_MAC_OVERRIDE CAP_LINUX_IMMUTABLE
+
+/*
+ * These functions are in smackfs.c
+ */
+void smk_cipso_doi(void);
+
+/*
+ * These functions are in smack_lsm.c
+ */
+struct inode_smack *new_inode_smack(char *);
+
+/*
+ * These functions are in smack_access.c
+ */
+int smk_access(char *, char *, int);
+int smk_curacc(char *, u32);
+int smack_to_cipso(const char *, struct smack_cipso *);
+void smack_from_cipso(u32, char *, char *);
+char *smack_from_secid(const u32);
+char *smk_import(const char *, int);
+struct smack_known *smk_import_entry(const char *, int);
+u32 smack_to_secid(const char *);
+
+/*
+ * Stricly for CIPSO level manipulation.
+ * Set the category bit number in a smack label sized buffer.
+ */
+static inline void smack_catset_bit(int cat, char *catsetp)
+{
+        char *cp = (char *)catsetp;
+
+        if (cat > SMK_LABELLEN * 8)
+                return;
+
+        cp[(cat - 1) / 8] |= 0x80 >> ((cat - 1) % 8);
+}
+
+/*
+ * Present a pointer to the smack label in an inode blob.
+ */
+static inline char *smk_of_inode(const struct inode *isp)
+{
+	struct inode_smack *sip = isp->i_security;
+	return sip->smk_inode;
+}
+
+#endif  /* _SECURITY_SMACK_H */
diff -puN /dev/null security/smack/smack_lsm.c
--- /dev/null
+++ a/security/smack/smack_lsm.c
@@ -0,0 +1,2685 @@
+/*
+ *  Simplified MAC Kernel (smack) security module
+ *
+ *  This file contains the smack hook function implementations.
+ *
+ *  Author:
+ *	Casey Schaufler <casey@schaufler-ca.com>
+ *
+ *  Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License version 2,
+ *      as published by the Free Software Foundation.
+ */
+
+#include <linux/xattr.h>
+#include <linux/pagemap.h>
+#include <linux/mount.h>
+#include <linux/stat.h>
+#include <linux/ext2_fs.h>
+#include <linux/kd.h>
+#include <asm/ioctls.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <linux/mutex.h>
+#include <net/netlabel.h>
+#include <net/cipso_ipv4.h>
+
+#include "smack.h"
+
+/*
+ * I hope these are the hokeyist lines of code in the module. Casey.
+ */
+#define DEVPTS_SUPER_MAGIC	0x1cd1
+#define SOCKFS_MAGIC		0x534F434B
+#define PIPEFS_MAGIC		0x50495045
+#define TMPFS_MAGIC		0x01021994
+
+/*
+ * These are in smack_access.c
+ */
+extern struct smack_known smack_known_unset;
+extern struct smack_known smack_known_huh;
+extern struct smack_known smack_known_hat;
+extern struct smack_known smack_known_star;
+extern struct smack_known smack_known_floor;
+extern struct smack_known smack_known_invalid;
+
+/*
+ * These are maintained in smackfs.c
+ */
+extern char *smack_net_ambient;
+extern int smack_net_nltype;
+extern int smack_cipso_direct;
+
+/**
+ * smk_fetch - Fetch the smack label from a file.
+ * @ip: a pointer to the inode
+ * @dp: a pointer to the dentry
+ *
+ * Returns a pointer to the master list entry for the Smack label
+ * or NULL if there was no label to fetch.
+ */
+static char *smk_fetch(struct inode *ip, struct dentry *dp)
+{
+	int rc;
+	char in[SMK_LABELLEN];
+
+	if (ip->i_op->getxattr == NULL)
+		return NULL;
+
+	rc = ip->i_op->getxattr(dp, XATTR_NAME_SMACK, in, SMK_LABELLEN);
+	if (rc < 0)
+		return NULL;
+
+	return smk_import(in, rc);
+}
+
+/**
+ * new_inode_smack - allocate an inode security blob
+ * @smack: a pointer to the Smack label to use in the blob
+ *
+ * Returns the new blob or NULL if there's no memory available
+ */
+struct inode_smack *new_inode_smack(char *smack)
+{
+	struct inode_smack *isp;
+
+	isp = kzalloc(sizeof(struct inode_smack), GFP_KERNEL);
+	if (isp == NULL)
+		return NULL;
+
+	isp->smk_inode = smack;
+	isp->smk_flags = 0;
+	mutex_init(&isp->smk_lock);
+
+	return isp;
+}
+
+/*
+ * LSM hooks.
+ * We he, that is fun!
+ */
+
+/**
+ * smack_ptrace - Smack approval on ptrace
+ * @ptp: parent task pointer
+ * @ctp: child task pointer
+ *
+ * Returns 0 if access is OK, an error code otherwise
+ *
+ * Do the capability checks, and require read and write.
+ */
+static int smack_ptrace(struct task_struct *ptp, struct task_struct *ctp)
+{
+	int rc;
+
+	rc = cap_ptrace(ptp, ctp);
+	if (rc != 0)
+		return rc;
+
+	rc = smk_access(ptp->security, ctp->security, MAY_READWRITE);
+	if (rc != 0 && __capable(ptp, CAP_MAC_OVERRIDE))
+		return 0;
+
+	return rc;
+}
+
+/**
+ * smack_syslog - Smack approval on syslog
+ * @type: message type
+ *
+ * Require that the task has the floor label
+ *
+ * Returns 0 on success, error code otherwise.
+ */
+static int smack_syslog(int type)
+{
+	int rc;
+	char *sp = current->security;
+
+	rc = cap_syslog(type);
+	if (rc != 0)
+		return rc;
+
+	if (__capable(current, CAP_MAC_OVERRIDE))
+		return 0;
+
+	 if (sp != smack_known_floor.smk_known)
+		rc = -EACCES;
+
+	return rc;
+}
+
+/**
+ * smack_task_alloc_security - "allocate" a task blob
+ * @tsk: the task in need of a blob
+ *
+ * Smack isn't using copies of blobs. Everyone
+ * points to an immutible list. No alloc required.
+ * No data copy required.
+ *
+ * Always returns 0
+ */
+static int smack_task_alloc_security(struct task_struct *tsk)
+{
+	tsk->security = current->security;
+
+	return 0;
+}
+
+/**
+ * smack_task_free_security - "free" a task blob
+ * @task: the task with the blob
+ *
+ * Smack isn't using copies of blobs. Everyone
+ * points to an immutible list. The blobs never go away.
+ * There is no leak here.
+ */
+static void smack_task_free_security(struct task_struct *task)
+{
+	task->security = NULL;
+}
+
+/**
+ * smack_task_setpgid - Smack check on setting pgid
+ * @p: the task object
+ * @pgid: unused
+ *
+ * Return 0 if write access is permitted
+ */
+static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
+{
+	return smk_curacc(p->security, MAY_WRITE);
+}
+
+/**
+ * smack_task_setnice - Smack check on setting nice
+ * @p: the task object
+ * @nice: unused
+ *
+ * Return 0 if write access is permitted
+ */
+static int smack_task_setnice(struct task_struct *p, int nice)
+{
+	return smk_curacc(p->security, MAY_WRITE);
+}
+
+/**
+ * smack_task_setioprio - Smack check on setting ioprio
+ * @p: the task object
+ * @ioprio: unused
+ *
+ * Return 0 if write access is permitted
+ */
+static int smack_task_setioprio(struct task_struct *p, int ioprio)
+{
+	return smk_curacc(p->security, MAY_WRITE);
+}
+
+/**
+ * smack_task_getioprio - Smack check on reading ioprio
+ * @p: the task object
+ *
+ * Return 0 if read access is permitted
+ */
+static int smack_task_getioprio(struct task_struct *p)
+{
+	return smk_curacc(p->security, MAY_READ);
+}
+
+/**
+ * smack_task_setscheduler - Smack check on setting scheduler
+ * @p: the task object
+ * @policy: unused
+ * @lp: unused
+ *
+ * Return 0 if read access is permitted
+ */
+static int smack_task_setscheduler(struct task_struct *p, int policy,
+				   struct sched_param *lp)
+{
+	return smk_curacc(p->security, MAY_WRITE);
+}
+
+/**
+ * smack_task_getscheduler - Smack check on reading scheduler
+ * @p: the task object
+ *
+ * Return 0 if read access is permitted
+ */
+static int smack_task_getscheduler(struct task_struct *p)
+{
+	return smk_curacc(p->security, MAY_READ);
+}
+
+/**
+ * smack_task_movememory - Smack check on moving memory
+ * @p: the task object
+ *
+ * Return 0 if write access is permitted
+ */
+static int smack_task_movememory(struct task_struct *p)
+{
+	return smk_curacc(p->security, MAY_WRITE);
+}
+
+/**
+ * smack_task_kill - Samck check on signal delivery
+ * @p: the task object
+ * @info: unused
+ * @sig: unused
+ * @secid: identifies the smack to use in lieu of current's
+ *
+ * Return 0 if write access is permitted
+ *
+ * The secid behavior is an artifact of an SELinux hack
+ * in the USB code. Someday it may go away.
+ */
+static int smack_task_kill(struct task_struct *p, struct siginfo *info,
+			   int sig, u32 secid)
+{
+	/*
+	 * Sending a signal requires that the sender
+	 * can write the receiver.
+	 */
+	if (secid == 0)
+		return smk_curacc(p->security, MAY_WRITE);
+	/*
+	 * If the secid isn't 0 we're dealing with some USB IO
+	 * specific behavior. This is not clean. For one thing
+	 * we can't take privilege into account.
+	 */
+	return smk_access(smack_from_secid(secid), p->security, MAY_WRITE);
+}
+
+/*
+ * Superblock Hooks.
+ */
+
+/**
+ * smack_sb_alloc_security - allocate a superblock blob
+ * @sb: the superblock getting the blob
+ *
+ * Returns 0 on success or -ENOMEM on error.
+ */
+static int smack_sb_alloc_security(struct super_block *sb)
+{
+	struct superblock_smack *sbsp;
+
+	sbsp = kzalloc(sizeof(struct superblock_smack), GFP_KERNEL);
+
+	if (sbsp == NULL)
+		return -ENOMEM;
+
+	sbsp->smk_root = smack_known_floor.smk_known;
+	sbsp->smk_default = smack_known_floor.smk_known;
+	sbsp->smk_floor = smack_known_floor.smk_known;
+	sbsp->smk_hat = smack_known_hat.smk_known;
+	sbsp->smk_initialized = 0;
+
+	sb->s_security = sbsp;
+
+	return 0;
+}
+
+/**
+ * smack_sb_free_security - free a superblock blob
+ * @sb: the superblock getting the blob
+ *
+ */
+static void smack_sb_free_security(struct super_block *sb)
+{
+	kfree(sb->s_security);
+	sb->s_security = NULL;
+}
+
+/**
+ * smack_sb_copy_data - copy mount options data for processing
+ * @type: file system type
+ * @orig: where to start
+ * @smackopts
+ *
+ * Returns 0 on success or -ENOMEM on error.
+ *
+ * Copy the Smack specific mount options out of the mount
+ * options list.
+ */
+static int smack_sb_copy_data(struct file_system_type *type, void *orig,
+			      void *smackopts)
+{
+	char *cp, *commap, *otheropts, *dp;
+
+	/* Binary mount data: just copy */
+	if (type->fs_flags & FS_BINARY_MOUNTDATA) {
+		copy_page(smackopts, orig);
+		return 0;
+	}
+
+	otheropts = (char *)get_zeroed_page(GFP_KERNEL);
+	if (otheropts == NULL)
+		return -ENOMEM;
+
+	for (cp = orig, commap = orig; commap != NULL; cp = commap + 1) {
+		if (strstr(cp, SMK_FSDEFAULT) == cp)
+			dp = smackopts;
+		else if (strstr(cp, SMK_FSFLOOR) == cp)
+			dp = smackopts;
+		else if (strstr(cp, SMK_FSHAT) == cp)
+			dp = smackopts;
+		else if (strstr(cp, SMK_FSROOT) == cp)
+			dp = smackopts;
+		else
+			dp = otheropts;
+
+		commap = strchr(cp, ',');
+		if (commap != NULL)
+			*commap = '\0';
+
+		if (*dp != '\0')
+			strcat(dp, ",");
+		strcat(dp, cp);
+	}
+
+	strcpy(orig, otheropts);
+	free_page((unsigned long)otheropts);
+
+	return 0;
+}
+
+/**
+ * smack_sb_kern_mount - Smack specific mount processing
+ * @sb: the file system superblock
+ * @data: the smack mount options
+ *
+ * Returns 0 on success, an error code on failure
+ */
+static int smack_sb_kern_mount(struct super_block *sb, void *data)
+{
+	int rc;
+	struct dentry *root = sb->s_root;
+	struct inode *inode = root->d_inode;
+	struct superblock_smack *sp = sb->s_security;
+	struct inode_smack *isp;
+	char *op;
+	char *commap;
+	char *nsp;
+
+	if (sp == NULL) {
+		rc = smack_sb_alloc_security(sb);
+		if (rc != 0)
+			return rc;
+	}
+	if (sp->smk_initialized != 0)
+		return 0;
+	if (inode == NULL)
+		return 0;
+
+	sp->smk_initialized = 1;
+
+	for (op = data; op != NULL; op = commap) {
+		commap = strchr(op, ',');
+		if (commap != NULL)
+			*commap++ = '\0';
+
+		if (strncmp(op, SMK_FSHAT, strlen(SMK_FSHAT)) == 0) {
+			op += strlen(SMK_FSHAT);
+			nsp = smk_import(op, 0);
+			if (nsp != NULL)
+				sp->smk_hat = nsp;
+		} else if (strncmp(op, SMK_FSFLOOR, strlen(SMK_FSFLOOR)) == 0) {
+			op += strlen(SMK_FSFLOOR);
+			nsp = smk_import(op, 0);
+			if (nsp != NULL)
+				sp->smk_floor = nsp;
+		} else if (strncmp(op,SMK_FSDEFAULT,strlen(SMK_FSDEFAULT))==0) {
+			op += strlen(SMK_FSDEFAULT);
+			nsp = smk_import(op, 0);
+			if (nsp != NULL)
+				sp->smk_default = nsp;
+		} else if (strncmp(op, SMK_FSROOT, strlen(SMK_FSROOT)) == 0) {
+			op += strlen(SMK_FSROOT);
+			nsp = smk_import(op, 0);
+			if (nsp != NULL)
+				sp->smk_root = nsp;
+		}
+	}
+
+	/*
+	 * Initialize the root inode.
+	 */
+	isp = inode->i_security;
+	if (isp == NULL)
+		inode->i_security = new_inode_smack(sp->smk_root);
+	else
+		isp->smk_inode = sp->smk_root;
+
+	return 0;
+}
+
+/**
+ * smack_sb_statfs - Smack check on statfs
+ * @dentry: identifies the file system in question
+ *
+ * Returns 0 if current can read the floor of the filesystem,
+ * and error code otherwise
+ */
+static int smack_sb_statfs(struct dentry *dentry)
+{
+	struct superblock_smack *sbp;
+
+	if (dentry == NULL || dentry->d_sb == NULL ||
+	    dentry->d_sb->s_security == NULL)
+		return 0;
+
+	sbp = dentry->d_sb->s_security;
+
+	return smk_curacc(sbp->smk_floor, MAY_READ);
+}
+
+/**
+ * smack_sb_mount - Smack check for mounting
+ * @dev_name: unused
+ * @nd: mount point
+ * @type: unused
+ * @flags: unused
+ * @data: unused
+ *
+ * Returns 0 if current can write the floor of the filesystem
+ * being mounted on, an error code otherwise.
+ */
+static int smack_sb_mount(char *dev_name, struct nameidata *nd,
+			  char *type, unsigned long flags, void *data)
+{
+	struct superblock_smack *sbp;
+
+	if (nd == NULL || nd->mnt == NULL || nd->mnt->mnt_sb == NULL ||
+	    nd->mnt->mnt_sb->s_security == NULL)
+		return 0;
+
+	sbp = nd->mnt->mnt_sb->s_security;
+
+	return smk_curacc(sbp->smk_floor, MAY_WRITE);
+}
+
+/**
+ * smack_sb_umount - Smack check for unmounting
+ * @mnt: file system to unmount
+ * @flags: unused
+ *
+ * Returns 0 if current can write the floor of the filesystem
+ * being unmounted, an error code otherwise.
+ */
+static int smack_sb_umount(struct vfsmount *mnt, int flags)
+{
+	struct superblock_smack *sbp;
+
+	sbp = mnt->mnt_sb->s_security;
+
+	return smk_curacc(sbp->smk_floor, MAY_WRITE);
+}
+
+/*
+ * Inode hooks
+ */
+
+/**
+ * smack_inode_alloc_security - allocate an inode blob
+ * @inode - the inode in need of a blob
+ *
+ * Returns 0 if it gets a blob, -ENOMEM otherwise
+ */
+static int smack_inode_alloc_security(struct inode *inode)
+{
+	inode->i_security = new_inode_smack(current->security);
+	if (inode->i_security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+/**
+ * smack_inode_free_security - free an inode blob
+ * @inode - the inode with a blob
+ *
+ * Clears the blob pointer in inode
+ */
+static void smack_inode_free_security(struct inode *inode)
+{
+	kfree(inode->i_security);
+	inode->i_security = NULL;
+}
+
+/**
+ * smack_inode_init_security - copy out the smack from an inode
+ * @inode: the inode
+ * @dir: unused
+ * @name: where to put the attribute name
+ * @value: where to put the attribute value
+ * @len: where to put the length of the attribute
+ *
+ * Returns 0 if it all works out, -ENOMEM if there's no memory
+ */
+static int smack_inode_init_security(struct inode *inode, struct inode *dir,
+			             char **name, void **value, size_t *len)
+{
+	char *isp = smk_of_inode(inode);
+
+	if (name) {
+		*name = kstrdup(XATTR_SMACK_SUFFIX, GFP_KERNEL);
+		if (*name == NULL)
+			return -ENOMEM;
+	}
+
+	if (value) {
+		*value = kstrdup(isp, GFP_KERNEL);
+		if (*value == NULL)
+			return -ENOMEM;
+	}
+
+	if (len)
+		*len = strlen(isp) + 1;
+
+	return 0;
+}
+
+/**
+ * smack_inode_link - Smack check on link
+ * @old_dentry: unused
+ * @dir: the directory with the entry to change
+ * @new_dentry: unused
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
+			    struct dentry *new_dentry)
+{
+	return smk_curacc(smk_of_inode(dir), MAY_WRITE);
+}
+
+/**
+ * smack_inode_symlink - Smack check on symlink
+ * @dir: the directory to add the entry to
+ * @dentry: unused
+ * @name: unused
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_symlink(struct inode *dir, struct dentry *dentry,
+			       const char *name)
+{
+	return smk_curacc(smk_of_inode(dir), MAY_WRITE);
+}
+
+/**
+ * smack_inode_mknod - Smack check on mknod
+ * @dir: the directory to add the entry to
+ * @dentry: unused
+ * @mode: unused
+ * @dev: unused
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_mknod(struct inode *dir, struct dentry *dentry,
+			     int mode, dev_t dev)
+{
+	return smk_curacc(smk_of_inode(dir), MAY_WRITE);
+}
+
+/**
+ * smack_inode_rename - Smack check on rename
+ * @old_inode: the old directory
+ * @old_dentry: unused
+ * @new_inode: the new directory
+ * @new_dentry: unused
+ *
+ * Read and write access is required on both the old and
+ * new directories.
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_rename(struct inode *old_inode,
+			      struct dentry *old_dentry,
+			      struct inode *new_inode,
+			      struct dentry *new_dentry)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(old_inode), MAY_READWRITE);
+	if (rc == 0)
+		rc = smk_curacc(smk_of_inode(new_inode), MAY_READWRITE);
+	return rc;
+}
+
+/**
+ * smack_inode_readlink - Smack check on readlink
+ * @dentry: the symlink
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_readlink(struct dentry *dentry)
+{
+	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+}
+
+/**
+ * smack_inode_follow_link - Smack check on following a symlink
+ * @dentry: the symlink
+ * @nameidata: unused
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_follow_link(struct dentry *dentry,
+				   struct nameidata *nameidata)
+{
+	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+}
+
+/**
+ * smack_inode_permission - Smack version of permission()
+ * @inode: the inode in question
+ * @mask: the access requested
+ * @nd: unused
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_permission(struct inode *inode, int mask,
+				  struct nameidata *nd)
+{
+	/*
+	 * No permission to check. Existence test. Yup, it's there.
+	 */
+	if (mask == 0)
+		return 0;
+
+	return smk_curacc(smk_of_inode(inode), mask);
+}
+
+/**
+ * smack_inode_setattr - Smack check for setting attributes
+ * @dentry: the object
+ * @iattr: unused
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+}
+
+/**
+ * smack_inode_getattr - Smack check for getting attributes
+ * @mnt: unused
+ * @dentry: the object
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
+{
+	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+}
+
+/**
+ * smack_inode_setxattr - Smack check for setting xattrs
+ * @dentry: the object
+ * @name: passed to the cap call
+ * @value: passed to the cap call
+ * @size: passed to the cap call
+ * @flags: passed to the cap call
+ *
+ * Check with cap_inode_setxattr to see if the capability
+ * scheme approves, then check the Smack access
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_setxattr(struct dentry *dentry, char *name,
+			        void *value, size_t size, int flags)
+{
+	int rc;
+
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
+		!__capable(current, CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	rc = cap_inode_setxattr(dentry, name, value, size, flags);
+	if (rc == 0)
+		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+
+	return rc;
+}
+
+/**
+ * smack_inode_post_setxattr - Apply the Smack update approved above
+ * @dentry: object
+ * @name: attribute name
+ * @value: attribute value
+ * @size: attribute size
+ * @flags: unused
+ *
+ * Set the pointer in the inode blob to the entry found
+ * in the master label list.
+ */
+static void smack_inode_post_setxattr(struct dentry *dentry, char *name,
+				      void *value, size_t size, int flags)
+{
+	struct inode_smack *isp;
+	char *nsp;
+
+	/*
+	 * Not SMACK
+	 */
+	if (strcmp(name, XATTR_NAME_SMACK))
+		return;
+
+	if (size >= SMK_LABELLEN)
+		return;
+
+	isp = dentry->d_inode->i_security;
+
+	/*
+	 * No locking is done here. This is a pointer
+	 * assignment.
+	 */
+	nsp = smk_import(value, size);
+	if (nsp != NULL)
+		isp->smk_inode = nsp;
+	else
+		isp->smk_inode = smack_known_invalid.smk_known;
+
+	return;
+}
+
+/*
+ * smack_inode_getxattr - Smack check on getxattr
+ * @dentry: the object
+ * @name: unused
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_getxattr(struct dentry *dentry, char *name)
+{
+	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+}
+
+/*
+ * smack_inode_listxattr - Smack check on listxattr
+ * @dentry: the object
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_listxattr(struct dentry *dentry)
+{
+	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+}
+
+/*
+ * smack_inode_removexattr - Smack check on removexattr
+ * @dentry: the object
+ * @name: name of the attribute
+ *
+ * Removing the Smack attribute requires CAP_MAC_OVERRIDE
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_removexattr(struct dentry *dentry, char *name)
+{
+	int rc;
+
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
+		!__capable(current, CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	rc = cap_inode_removexattr(dentry, name);
+	if (rc == 0)
+		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+
+	return rc;
+}
+
+/**
+ * smack_inode_getsecurity - get smack xattrs
+ * @inode: the object
+ * @name: attribute name
+ * @buffer: where to put the result
+ * @size: size of the buffer
+ * @err: unused
+ *
+ * Returns the size of the attribute or an error code
+ */
+static int smack_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
+{
+	struct socket_smack *ssp;
+	struct socket *sock;
+	struct super_block *sbp;
+	struct inode *ip = (struct inode *)inode;
+	char *bsp = buffer;
+	char *isp;
+
+	if (size < SMK_LABELLEN || name == NULL || bsp == NULL ||
+	    inode == NULL || inode->i_security == NULL)
+		return 0;
+
+	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
+		isp = smk_of_inode(inode);
+		strncpy(buffer, isp, SMK_LABELLEN);
+		return strlen(isp) + 1;
+	}
+
+	/*
+	 * The rest of the Smack xattrs are only on sockets.
+	 */
+	sbp = ip->i_sb;
+	if (sbp->s_magic != SOCKFS_MAGIC)
+		return -EOPNOTSUPP;
+
+	sock = SOCKET_I(ip);
+	if (sock == NULL)
+		return -EOPNOTSUPP;
+
+	ssp = sock->sk->sk_security;
+
+	/*
+	 * Should the packet attribute be unavailable return the error.
+	 * This can happen if packets come in too fast.
+	 */
+	if (strcmp(name, XATTR_SMACK_PACKET) == 0) {
+		if (ssp->smk_packet[0] == '\0')
+			return -ENODATA;
+		isp = ssp->smk_packet;
+	}
+	else if (strcmp(name, XATTR_SMACK_IPIN) == 0)
+		isp = ssp->smk_in;
+	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
+		isp = ssp->smk_out;
+	else
+		return -EOPNOTSUPP;
+
+	strncpy(buffer, isp, SMK_LABELLEN);
+	return strlen(isp) + 1;
+}
+
+/**
+ * smack_inode_setsecurity - set smack xattrs
+ * @inode: the object
+ * @name: attribute name
+ * @value: attribute value
+ * @size: size of the attribute
+ * @flags: unused
+ *
+ * Sets the named attribute in the appropriate blob
+ *
+ * Returns 0 on success, or an error code
+ */
+static int smack_inode_setsecurity(struct inode *inode, const char *name,
+				   const void *value, size_t size, int flags)
+{
+	char *sp;
+	struct inode_smack *nsp = (struct inode_smack *)inode->i_security;
+	struct socket_smack *ssp;
+	struct socket *sock;
+
+	if (value == NULL || size > SMK_LABELLEN)
+		return -EACCES;
+
+	sp = smk_import(value, size);
+	if (sp == NULL)
+		return -EINVAL;
+
+	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
+		mutex_lock(&nsp->smk_lock);
+		nsp->smk_inode = sp;
+		mutex_unlock(&nsp->smk_lock);
+		return 0;
+	}
+	/*
+	 * The rest of the Smack xattrs are only on sockets.
+	 */
+	if (inode->i_sb->s_magic != SOCKFS_MAGIC)
+		return -EOPNOTSUPP;
+
+	sock = SOCKET_I(inode);
+	if (sock == NULL)
+		return -EOPNOTSUPP;
+
+	ssp = sock->sk->sk_security;
+
+	if (strcmp(name, XATTR_SMACK_PACKET) == 0) {
+		memset(ssp->smk_packet, '\0', SMK_LABELLEN);
+		strncpy(ssp->smk_packet, sp, SMK_LABELLEN);
+	}
+	else if (strcmp(name, XATTR_SMACK_IPIN) == 0)
+		ssp->smk_in = sp;
+	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
+		ssp->smk_out = sp;
+	else
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+/**
+ * smack_inode_listsecurity - list the Smack attributes
+ * @inode: the object
+ * @buffer: where they go
+ * @buffer_size: size of buffer
+ *
+ * Returns 0 on success, -EINVAL otherwise
+ */
+static int smack_inode_listsecurity(struct inode *inode, char *buffer,
+				    size_t buffer_size)
+{
+	int len = strlen(XATTR_NAME_SMACK);
+
+	if (buffer != NULL && len <= buffer_size) {
+		memcpy(buffer, XATTR_NAME_SMACK, len);
+		return len;
+	}
+	return -EINVAL;
+}
+
+/**
+ * smack_d_instantiate - Make sure the blob is correct on an inode
+ * @opt_dentry: unused
+ * @inode: the object
+ *
+ * Set the inode's security blob if it hasn't been done already.
+ */
+static void smack_d_instantiate (struct dentry *opt_dentry, struct inode *inode)
+{
+	struct super_block *sbp;
+	struct superblock_smack *sbsp;
+	struct inode_smack *isp;
+	char *csp = current->security;
+	char *fetched;
+	char *final;
+	struct dentry *dp;
+
+	if (inode == NULL)
+		return;
+
+	if (inode->i_security == NULL)
+		inode->i_security =
+			new_inode_smack(smack_known_unset.smk_known);
+
+	isp = inode->i_security;
+
+	mutex_lock(&isp->smk_lock);
+	/*
+	 * If the inode is already instantiated
+	 * take the quick way out
+	 */
+	if (isp->smk_flags & SMK_INODE_INSTANT)
+		goto unlockandout;
+
+	sbp = inode->i_sb;
+	sbsp = sbp->s_security;
+	/*
+	 * We're going to use the superblock default label
+	 * if there's no label on the file.
+	 */
+	final = sbsp->smk_default;
+
+	/*
+	 * This is pretty hackish.
+	 * Casey says that we shouldn't have to do
+	 * file system specific code, but it does help
+	 * with keeping it simple.
+	 */
+	switch (sbp->s_magic) {
+	case SMACK_MAGIC:
+		/*
+		 * Casey says that it's a little embarassing
+		 * that the smack file system doesn't do
+		 * extended attributes.
+		 */
+		final = smack_known_star.smk_known;
+		break;
+	case PIPEFS_MAGIC:
+		/*
+		 * Casey says pipes are easy (?)
+		 */
+		final = smack_known_star.smk_known;
+		break;
+	case DEVPTS_SUPER_MAGIC:
+		/*
+		 * devpts seems content with the label of the task.
+		 * Programs that change smack have to treat the
+		 * pty with respect.
+		 */
+		final = csp;
+		break;
+	case SOCKFS_MAGIC:
+		/*
+		 * Casey says sockets get the smack of the task.
+		 */
+		final = csp;
+		break;
+	case PROC_SUPER_MAGIC:
+		/*
+		 * Casey says procfs appears not to care.
+		 * The superblock default suffices.
+		 */
+		break;
+	case TMPFS_MAGIC:
+		/*
+		 * Device labels should come from the filesystem,
+		 * but watch out, because they're volitile,
+		 * getting recreated on every reboot.
+		 */
+		final = smack_known_star.smk_known;
+		/*
+		 * No break.
+		 *
+		 * If a smack value has been set we want to use it,
+		 * but since tmpfs isn't giving us the opportunity
+		 * to set mount options simulate setting the
+		 * superblock default.
+		 */
+	default:
+		/*
+		 * This isn't an understood special case.
+		 * Get the value from the xattr.
+		 *
+		 * No xattr support means, alas, no SMACK label.
+		 * Use the aforeapplied default.
+		 * It would be curious if the label of the task
+		 * does not match that assigned.
+		 */
+		if (inode->i_op->getxattr == NULL)
+			break;
+		/*
+		 * Get the dentry for xattr.
+		 */
+		if (opt_dentry == NULL) {
+			dp = d_find_alias(inode);
+			if (dp == NULL)
+				break;
+		} else {
+			dp = dget(opt_dentry);
+			if (dp == NULL)
+				break;
+		}
+
+		fetched = smk_fetch(inode, dp);
+		if (fetched != NULL)
+			final = fetched;
+
+		dput(dp);
+		break;
+	}
+
+	if (final == NULL)
+		isp->smk_inode = csp;
+	else
+		isp->smk_inode = final;
+
+	isp->smk_flags |= SMK_INODE_INSTANT;
+
+unlockandout:
+	mutex_unlock(&isp->smk_lock);
+	return;
+}
+
+/*
+ * File Hooks
+ */
+
+/**
+ * smack_file_alloc_security - assign a file security blob
+ * @file: the object
+ *
+ * The security blob for a file is a pointer to the master
+ * label list, so no allocation is done.
+ *
+ * Returns 0
+ */
+static int smack_file_alloc_security(struct file *file)
+{
+	file->f_security = current->security;
+	return 0;
+}
+
+/**
+ * smack_file_free_security - clear a file security blob
+ * @file: the object
+ *
+ * The security blob for a file is a pointer to the master
+ * label list, so no memory is freed.
+ */
+static void smack_file_free_security(struct file *file)
+{
+	file->f_security = NULL;
+}
+
+/**
+ * smack_file_permission - Smack check on file operations
+ * @file: unused
+ * @mask: unused
+ *
+ * Returns 0
+ *
+ * Should access checks be done on each read or write?
+ * UNICOS and SELinux say yes.
+ * Trusted Solaris, Trusted Irix, and just about everyone else says no.
+ *
+ * I'll say no for now. Smack does not do the frequent
+ * label changing that SELinux does.
+ */
+static int smack_file_permission(struct file *file, int mask)
+{
+	return 0;
+}
+
+/**
+ * smack_file_ioctl - Smack check on ioctls
+ * @file: the object
+ * @cmd: what to do
+ * @arg: unused
+ *
+ * Relies heavily on the correct use of the ioctl command conventions.
+ *
+ * Returns 0 if allowed, error code otherwise
+ */
+static int smack_file_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	int rc = 0;
+
+	if (_IOC_DIR(cmd) & _IOC_WRITE)
+		rc = smk_curacc(file->f_security, MAY_WRITE);
+
+	if (rc == 0 && (_IOC_DIR(cmd) & _IOC_READ))
+		rc = smk_curacc(file->f_security, MAY_READ);
+
+	return rc;
+}
+
+/**
+ * smack_file_lock - Smack check on file locking
+ * @file: the object
+ * @cmd unused
+ *
+ * Returns 0 if current has write access, error code otherwise
+ */
+static int smack_file_lock(struct file *file, unsigned int cmd)
+{
+	return smk_curacc(file->f_security, MAY_WRITE);
+}
+
+/**
+ * smack_file_fcntl - Smack check on fcntl
+ * @file: the object
+ * @cmd: what action to check
+ * @arg: unused
+ *
+ * Returns 0 if current has access, error code otherwise
+ */
+static int smack_file_fcntl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	int rc;
+
+	switch (cmd) {
+	case F_DUPFD:
+	case F_GETFD:
+	case F_GETFL:
+	case F_GETLK:
+	case F_GETOWN:
+	case F_GETSIG:
+		rc = smk_curacc(file->f_security, MAY_READ);
+		break;
+	case F_SETFD:
+	case F_SETFL:
+	case F_SETLK:
+	case F_SETLKW:
+	case F_SETOWN:
+	case F_SETSIG:
+		rc = smk_curacc(file->f_security, MAY_WRITE);
+		break;
+	default:
+		rc = smk_curacc(file->f_security, MAY_READWRITE);
+	}
+
+	return rc;
+}
+
+/**
+ * smack_file_send_sigiotask - Smack on sigio
+ * @tsk: The target task
+ * @fown: the object the signal come from
+ * @signum: unused
+ *
+ * Allow a privileged task to get signals even if it shouldn't
+ *
+ * Returns 0 if a subject with the object's smack could
+ * write to the task, an error code otherwise.
+ */
+static int smack_file_send_sigiotask(struct task_struct *tsk,
+				     struct fown_struct *fown, int signum)
+{
+	struct file *file;
+	int rc;
+
+	/*
+	 * struct fown_struct is never outside the context of a struct file
+	 */
+	file = (struct file *)((long)fown - offsetof(struct file,f_owner));
+	rc = smk_access(file->f_security, tsk->security, MAY_WRITE);
+	if (rc != 0 && __capable(tsk, CAP_MAC_OVERRIDE))
+		return 0;
+	return rc;
+}
+
+/**
+ * smack_file_receive - Smack file receive check
+ * @file: the object
+ *
+ * Returns 0 if current has access, error code otherwise
+ */
+static int smack_file_receive(struct file *file)
+{
+	int may = 0;
+
+	/*
+	 * This code relies on bitmasks.
+	 */
+	if (file->f_mode & FMODE_READ)
+		may = MAY_READ;
+	if (file->f_mode & FMODE_WRITE)
+		may |= MAY_WRITE;
+
+	return smk_curacc(file->f_security, may);
+}
+
+/*
+ * Socket hooks.
+ */
+
+/**
+ * smack_sk_alloc_security - Allocate a socket blob
+ * @sk: the socket
+ * @family: unused
+ * @priority: memory allocation priority
+ *
+ * Assign Smack pointers to current except for smk_packet which
+ * is not a pointer but the real thing.
+ *
+ * Returns 0 on success, -ENOMEM is there's no memory
+ */
+static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t priority)
+{
+	char *csp = current->security;
+	struct socket_smack *ssp;
+
+	ssp = kzalloc(sizeof(struct socket_smack), priority);
+	if (ssp == NULL)
+		return -ENOMEM;
+
+	ssp->smk_in = csp;
+	ssp->smk_out = csp;
+	memset(ssp->smk_packet, '\0', SMK_LABELLEN);
+	strcpy(ssp->smk_packet, smack_known_invalid.smk_known);
+	ssp->smk_depth = 0;
+
+	sk->sk_security = ssp;
+
+	return 0;
+}
+
+/**
+ * smack_sk_free_security - Free a socket blob
+ * @sk: the socket
+ *
+ * Clears the blob pointer
+ */
+static void smack_sk_free_security(struct sock *sk)
+{
+	kfree(sk->sk_security);
+	sk->sk_security = NULL;
+}
+
+/**
+ * smack_set_catset - convert a capset to netlabel mls categories
+ * @catset: the Smack categories
+ * @sap: where to put the netlabel categories
+ *
+ * Allocates and fills mls_cat
+ */
+static void smack_set_catset(char *catset, struct netlbl_lsm_secattr *sap)
+{
+	unsigned char *cp;
+	unsigned char m;
+	int cat;
+	int rc;
+
+	if (catset == 0)
+		return;
+
+	sap->flags |= NETLBL_SECATTR_MLS_CAT;
+	sap->mls_cat = netlbl_secattr_catmap_alloc(GFP_ATOMIC);
+	sap->mls_cat->startbit = 0;
+
+	for (cat = 1, cp = catset; *cp != 0; cp++)
+		for (m = 0x80; m != 0; m >>= 1, cat++) {
+			if ((m & *cp) == 0)
+				continue;
+			rc = netlbl_secattr_catmap_setbit(sap->mls_cat, cat,
+							  GFP_ATOMIC);
+		}
+}
+
+/**
+ * smack_to_secattr - fill a secattr from a smack value
+ * @smack: the smack value
+ * @nlsp: where the result goes
+ *
+ * Casey says that CIPSO is good enough for now.
+ * It can be used to effect.
+ * It can also be abused to effect when necessary.
+ * Appologies to the TSIG group in general and GW in particular.
+ */
+static void smack_to_secattr(char *smack, struct netlbl_lsm_secattr *nlsp)
+{
+	struct smack_cipso cipso;
+	int rc;
+
+	switch (smack_net_nltype) {
+	case NETLBL_NLTYPE_CIPSOV4:
+		nlsp->domain = NULL;
+		nlsp->flags = NETLBL_SECATTR_DOMAIN;
+		nlsp->flags |= NETLBL_SECATTR_MLS_LVL;
+
+		rc = smack_to_cipso(smack, &cipso);
+		if (rc == 0) {
+			nlsp->mls_lvl = cipso.smk_level;
+			smack_set_catset(cipso.smk_catset, nlsp);
+		} else {
+			nlsp->mls_lvl = smack_cipso_direct;
+			smack_set_catset(smack, nlsp);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * smack_netlabel - Set the secattr on a socket
+ * @sk: the socket
+ *
+ * Convert the outbound smack value (smk_out) to a
+ * secattr and attach it to the socket.
+ *
+ * Returns 0 on success or an error code
+ */
+static int smack_netlabel(struct sock *sk)
+{
+	static int initialized;
+	struct socket_smack *ssp = sk->sk_security;
+	struct netlbl_lsm_secattr secattr;
+	int rc;
+
+	if (!initialized) {
+		smk_cipso_doi();
+		initialized = 1;
+	}
+
+	netlbl_secattr_init(&secattr);
+	smack_to_secattr(ssp->smk_out, &secattr);
+	if (secattr.flags != NETLBL_SECATTR_NONE)
+		rc = netlbl_sock_setattr(sk, &secattr);
+	else
+		rc = -EINVAL;
+
+	netlbl_secattr_destroy(&secattr);
+	return rc;
+}
+
+/**
+ * smack_socket_post_create - finish socket setup
+ * @sock: the socket
+ * @family: protocol family
+ * @type: unused
+ * @protocol: unused
+ * @kern: indicates kern vs task socket
+ *
+ * Sets the security blob on the socket's inode.
+ * Sets the secattr value for outgoing packets.
+ *
+ * Returns 0 on success, and error code otherwise
+ */
+static int smack_socket_post_create(struct socket *sock, int family,
+				    int type, int protocol, int kern)
+{
+	struct inode_smack *isp;
+
+	isp = SOCK_INODE(sock)->i_security;
+
+	if (isp == NULL) {
+		if (kern)
+			isp = new_inode_smack(smack_known_floor.smk_known);
+		else
+			isp = new_inode_smack(current->security);
+		SOCK_INODE(sock)->i_security = isp;
+	}
+
+	if (family != PF_INET)
+		return 0;
+
+	/*
+	 * Set the outbound netlbl.
+	 */
+	return smack_netlabel(sock->sk);
+}
+
+/**
+ * smack_inode_create - Smack check on inode creation
+ * @dir: containing directory object
+ * @dentry: unused
+ * @mode: unused
+ *
+ * Returns 0 if current can write the containing directory,
+ * error code otherwise
+ */
+static int smack_inode_create(struct inode *dir, struct dentry *dentry,
+			      int mode)
+{
+	return smk_curacc(smk_of_inode(dir), MAY_WRITE);
+}
+
+/**
+ * smack_inode_unlink - Smack check on inode deletion
+ * @dir: containing directory object
+ * @dentry: file to unlink
+ *
+ * Returns 0 if current can write the containing directory
+ * and the object, error code otherwise
+ */
+static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *ip = dentry->d_inode;
+	int rc;
+
+	/*
+	 * You need write access to the thing you're unlinking
+	 */
+	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE);
+	if (rc == 0)
+		/*
+		 * You also need write access to the containing directory
+		 */
+		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+
+	return rc;
+}
+
+/**
+ * smack_inode_mkdir - Smack check on directory creation
+ * @dir: containing directory object
+ * @dentry: unused
+ * @mode: unused
+ *
+ * Returns 0 if current can write the containing directory,
+ * error code otherwise
+ */
+static int smack_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	return smk_curacc(smk_of_inode(dir), MAY_WRITE);
+}
+
+/**
+ * smack_inode_rmdir - Smack check on directory deletion
+ * @dir: containing directory object
+ * @dentry: directory to unlink
+ *
+ * Returns 0 if current can write the containing directory
+ * and the directory, error code otherwise
+ */
+static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *ip = dentry->d_inode;
+	int rc;
+
+	/*
+	 * You need write access to the thing you're removing
+	 */
+	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE);
+	if (rc == 0)
+		/*
+		 * You also need write access to the containing directory
+		 */
+		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+
+	return rc;
+}
+
+/**
+ * smack_file_set_fowner - set the file security blob value
+ * @file: object in question
+ *
+ * Returns 0
+ * Further research may be required on this one.
+ */
+static int smack_file_set_fowner(struct file *file)
+{
+	file->f_security = current->security;
+	return 0;
+}
+
+/**
+ * smack_task_getpgid - Smack access check for getpgid
+ * @p: the object task
+ *
+ * Returns 0 if current can read the object task, error code otherwise
+ */
+static int smack_task_getpgid(struct task_struct *p)
+{
+	return smk_curacc(p->security, MAY_READ);
+}
+
+/**
+ * smack_task_getsid - Smack access check for getsid
+ * @p: the object task
+ *
+ * Returns 0 if current can read the object task, error code otherwise
+ */
+static int smack_task_getsid(struct task_struct *p)
+{
+	return smk_curacc(p->security, MAY_READ);
+}
+
+/**
+ * smack_task_getsecid - get the secid of the task
+ * @p: the object task
+ * @secid: where to put the result
+ *
+ * Sets the secid to contain a u32 version of the smack label.
+ */
+static void smack_task_getsecid(struct task_struct *p, u32 *secid)
+{
+	*secid = smack_to_secid(p->security);
+}
+
+/**
+ * smack_flags_to_may - convert S_ to MAY_ values
+ * @flags: the S_ value
+ *
+ * Returns the equivalent MAY_ value
+ */
+static int smack_flags_to_may(int flags)
+{
+	int may = 0;
+
+	if (flags & S_IRUGO)
+		may |= MAY_READ;
+	if (flags & S_IWUGO)
+		may |= MAY_WRITE;
+	if (flags & S_IXUGO)
+		may |= MAY_EXEC;
+
+	return may;
+}
+
+/**
+ * smack_msg_msg_alloc_security - Set the security blob for msg_msg
+ * @msg: the object
+ *
+ * Returns 0
+ */
+static int smack_msg_msg_alloc_security(struct msg_msg *msg)
+{
+	msg->security = current->security;
+	return 0;
+}
+
+/**
+ * smack_msg_msg_free_security - Clear the security blob for msg_msg
+ * @msg: the object
+ *
+ * Clears the blob pointer
+ */
+static void smack_msg_msg_free_security(struct msg_msg *msg)
+{
+	msg->security = NULL;
+}
+
+/**
+ * smack_of_shm - the smack pointer for the shm
+ * @shp: the object
+ *
+ * Returns a pointer to the smack value
+ */
+static char *smack_of_shm(struct shmid_kernel *shp)
+{
+	if (shp == NULL)
+		return NULL;
+
+	return (char *)shp->shm_perm.security;
+}
+
+/**
+ * smack_shm_alloc_security - Set the security blob for shm
+ * @shp: the object
+ *
+ * Returns 0
+ */
+static int smack_shm_alloc_security(struct shmid_kernel *shp)
+{
+	struct kern_ipc_perm *isp = &shp->shm_perm;
+
+	isp->security = current->security;
+	return 0;
+}
+
+/**
+ * smack_shm_free_security - Clear the security blob for shm
+ * @shp: the object
+ *
+ * Clears the blob pointer
+ */
+static void smack_shm_free_security(struct shmid_kernel *shp)
+{
+	struct kern_ipc_perm *isp = &shp->shm_perm;
+
+	isp->security = NULL;
+}
+
+/**
+ * smack_shm_associate - Smack access check for shm
+ * @shp: the object
+ * @shmflg: access requested
+ *
+ * Returns 0 if current has the requested access, error code otherwise
+ */
+static int smack_shm_associate(struct shmid_kernel *shp, int shmflg)
+{
+	char *ssp = smack_of_shm(shp);
+	int may;
+
+	if (ssp == NULL)
+		return 0;
+
+	may = smack_flags_to_may(shmflg);
+	return smk_curacc(ssp, may);
+}
+
+/**
+ * smack_shm_shmctl - Smack access check for shm
+ * @shp: the object
+ * @cmd: what it wants to do
+ *
+ * Returns 0 if current has the requested access, error code otherwise
+ */
+static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
+{
+	char *ssp = smack_of_shm(shp);
+	int may;
+
+	if (ssp == NULL)
+		return 0;
+
+	switch(cmd) {
+	case IPC_STAT:
+	case SHM_STAT:
+		may = MAY_READ;
+		break;
+	case IPC_SET:
+	case SHM_LOCK:
+	case SHM_UNLOCK:
+	case IPC_RMID:
+		may = MAY_READWRITE;
+		break;
+	case IPC_INFO:
+	case SHM_INFO:
+		/*
+		 * System level information.
+		 */
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	return smk_curacc(ssp, may);
+}
+
+/**
+ * smack_shm_shmat - Smack access for shmat
+ * @shp: the object
+ * @shmaddr: unused
+ * @shmflg: access requested
+ *
+ * Returns 0 if current has the requested access, error code otherwise
+ */
+static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
+			   int shmflg)
+{
+	char *ssp = smack_of_shm(shp);
+	int may;
+
+	if (ssp == NULL)
+		return 0;
+
+	may = smack_flags_to_may(shmflg);
+	return smk_curacc(ssp, may);
+}
+
+/**
+ * smack_of_sem - the smack pointer for the sem
+ * @sma: the object
+ *
+ * Returns a pointer to the smack value
+ */
+static char *smack_of_sem(struct sem_array *sma)
+{
+	if (sma == NULL)
+		return NULL;
+
+	return (char *)sma->sem_perm.security;
+}
+
+/**
+ * smack_sem_alloc_security - Set the security blob for sem
+ * @sma: the object
+ *
+ * Returns 0
+ */
+static int smack_sem_alloc_security(struct sem_array *sma)
+{
+	struct kern_ipc_perm *isp = &sma->sem_perm;
+
+	isp->security = current->security;
+	return 0;
+}
+
+/**
+ * smack_sem_free_security - Clear the security blob for sem
+ * @sma: the object
+ *
+ * Clears the blob pointer
+ */
+static void smack_sem_free_security(struct sem_array *sma)
+{
+	struct kern_ipc_perm *isp = &sma->sem_perm;
+
+	isp->security = NULL;
+}
+
+/**
+ * smack_sem_associate - Smack access check for sem
+ * @sma: the object
+ * @semflg: access requested
+ *
+ * Returns 0 if current has the requested access, error code otherwise
+ */
+static int smack_sem_associate(struct sem_array *sma, int semflg)
+{
+	char *ssp = smack_of_sem(sma);
+	int may;
+
+	if (ssp == NULL)
+		return 0;
+
+	may = smack_flags_to_may(semflg);
+	return smk_curacc(ssp, may);
+}
+
+/**
+ * smack_sem_shmctl - Smack access check for sem
+ * @sma: the object
+ * @cmd: what it wants to do
+ *
+ * Returns 0 if current has the requested access, error code otherwise
+ */
+static int smack_sem_semctl(struct sem_array *sma, int cmd)
+{
+	char *ssp = smack_of_sem(sma);
+	int may;
+
+	if (ssp == NULL)
+		return 0;
+
+	switch(cmd) {
+	case GETPID:
+	case GETNCNT:
+	case GETZCNT:
+	case GETVAL:
+	case GETALL:
+	case IPC_STAT:
+	case SEM_STAT:
+		may = MAY_READ;
+		break;
+	case SETVAL:
+	case SETALL:
+	case IPC_RMID:
+	case IPC_SET:
+		may = MAY_READWRITE;
+		break;
+	case IPC_INFO:
+	case SEM_INFO:
+		/*
+		 * System level information
+		 */
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	return smk_curacc(ssp, may);
+}
+
+/**
+ * smack_sem_semop - Smack checks of semaphore operations
+ * @sma: the object
+ * @sops: unused
+ * @nsops: unused
+ * @alter: unused
+ *
+ * Treated as read and write in all cases.
+ *
+ * Returns 0 if access is allowed, error code otherwise
+ */
+static int smack_sem_semop(struct sem_array *sma, struct sembuf *sops, unsigned nsops, int alter)
+{
+	char *ssp = smack_of_sem(sma);
+
+	if (ssp == NULL)
+		return 0;
+
+	return smk_curacc(ssp, MAY_READWRITE);
+}
+
+/**
+ * smack_msg_alloc_security - Set the security blob for msg
+ * @msq: the object
+ *
+ * Returns 0
+ */
+static int smack_msg_queue_alloc_security(struct msg_queue *msq)
+{
+	struct kern_ipc_perm *kisp = &msq->q_perm;
+
+	kisp->security = current->security;
+	return 0;
+}
+
+/**
+ * smack_msg_free_security - Clear the security blob for msg
+ * @msq: the object
+ *
+ * Clears the blob pointer
+ */
+static void smack_msg_queue_free_security(struct msg_queue *msq)
+{
+	struct kern_ipc_perm *kisp = &msq->q_perm;
+
+	kisp->security = NULL;
+}
+
+/**
+ * smack_of_msq - the smack pointer for the msq
+ * @msq: the object
+ *
+ * Returns a pointer to the smack value
+ */
+static char *smack_of_msq(struct msg_queue *msq)
+{
+	if (msq == NULL)
+		return NULL;
+
+	return (char *)msq->q_perm.security;
+}
+
+/**
+ * smack_msg_queue_associate - Smack access check for msg_queue
+ * @msq: the object
+ * @msqflg: access requested
+ *
+ * Returns 0 if current has the requested access, error code otherwise
+ */
+static int smack_msg_queue_associate(struct msg_queue *msq, int msqflg)
+{
+	char *msp = smack_of_msq(msq);
+	int may;
+
+	if (msp == NULL)
+		return 0;
+
+	may = smack_flags_to_may(msqflg);
+	return smk_curacc(msp, may);
+}
+
+/**
+ * smack_msg_queue_msgctl - Smack access check for msg_queue
+ * @msq: the object
+ * @cmd: what it wants to do
+ *
+ * Returns 0 if current has the requested access, error code otherwise
+ */
+static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
+{
+	char *msp = smack_of_msq(msq);
+	int may;
+
+	if (msp == NULL)
+		return 0;
+
+	switch(cmd) {
+	case IPC_STAT:
+	case MSG_STAT:
+		may = MAY_READ;
+		break;
+	case IPC_SET:
+	case IPC_RMID:
+		may = MAY_READWRITE;
+		break;
+	case IPC_INFO:
+	case MSG_INFO:
+		/*
+		 * System level information
+		 */
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	return smk_curacc(msp, may);
+}
+
+/**
+ * smack_msg_queue_msgsnd - Smack access check for msg_queue
+ * @msq: the object
+ * @msg: unused
+ * @msqflg: access requested
+ *
+ * Returns 0 if current has the requested access, error code otherwise
+ */
+static int smack_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
+				  int msqflg)
+{
+	char *msp = smack_of_msq(msq);
+	int rc;
+
+	if (msp == NULL)
+		return 0;
+
+	rc = smack_flags_to_may(msqflg);
+	return smk_curacc(msp, rc);
+}
+
+/**
+ * smack_msg_queue_msgsnd - Smack access check for msg_queue
+ * @msq: the object
+ * @msg: unused
+ * @target: unused
+ * @type: unused
+ * @mode: unused
+ *
+ * Returns 0 if current has read and write access, error code otherwise
+ */
+static int smack_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
+			struct task_struct *target, long type, int mode)
+{
+	char *msp = smack_of_msq(msq);
+
+	if (msp == NULL)
+		return 0;
+
+	return smk_curacc(msp, MAY_READWRITE);
+}
+
+/**
+ * smack_ipc_permission - Smack access for ipc_permission()
+ * @ipp: the object permissions
+ * @flag: access requested
+ *
+ * Returns 0 if current has read and write access, error code otherwise
+ */
+static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
+{
+	char *isp = ipp->security;
+	int may;
+
+	may = smack_flags_to_may(flag);
+	return smk_curacc(isp, may);
+}
+
+/**
+ * smack_task_to_inode - copy task smack into the inode blob
+ * @p: task to copy from
+ * inode: inode to copy to
+ *
+ * Sets the smack pointer in the inode security blob
+ */
+static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
+{
+	struct inode_smack *isp = inode->i_security;
+	isp->smk_inode = p->security;
+}
+
+/**
+ * smack_task_wait - Smack access check for waiting
+ * @p: task to wait for
+ *
+ * Returns 0 if current can wait for p, error code otherwise
+ */
+static int smack_task_wait(struct task_struct *p)
+{
+	int rc;
+
+	rc = smk_access(current->security, p->security, MAY_WRITE);
+	if (rc == 0)
+		return 0;
+
+	/*
+	 * Allow the operation to succeed if either task
+	 * has privilege to perform operations that might
+	 * account for the smack labels having gotten to
+	 * be different in the first place.
+	 *
+	 * This breaks the strict subjet/object access
+	 * control ideal, taking the object's privilege
+	 * state into account in the decision as well as
+	 * the smack value.
+	 */
+	if (__capable(current, CAP_MAC_OVERRIDE) ||
+		__capable(p, CAP_MAC_OVERRIDE))
+		return 0;
+
+	return rc;
+}
+
+/**
+ * smack_getprocattr - Smack process attribute access
+ * @p: the object task
+ * @name: the name of the attribute in /proc/.../attr
+ * @value: where to put the result
+ *
+ * Places a copy of the task Smack into value
+ *
+ * Returns the length of the smack label or an error code
+ */
+static int smack_getprocattr(struct task_struct *p, char *name, char **value)
+{
+	char *cp;
+	int slen;
+
+	if (strcmp(name, "current") != 0)
+		return -EINVAL;
+
+	cp = kstrdup(current->security, GFP_KERNEL);
+	if (cp == NULL)
+		return -ENOMEM;
+
+	slen = strlen(cp);
+	*value = cp;
+	return slen;
+}
+
+/**
+ * smack_setprocattr - Smack process attribute setting
+ * @p: the object task
+ * @name: the name of the attribute in /proc/.../attr
+ * @value: the value to set
+ * @size: the size of the value
+ *
+ * Sets the Smack value of the task. Only setting self
+ * is permitted and only with privilege
+ *
+ * Returns the length of the smack label or an error code
+ */
+static int smack_setprocattr(struct task_struct *p, char *name,
+			     void *value, size_t size)
+{
+	char *newsmack;
+
+	if (!__capable(p, CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	/*
+	 * Changing another process' Smack value is too dangerous
+	 * and supports no sane use case.
+	 */
+	if (p != current)
+		return -EPERM;
+
+	if (value == NULL || size == 0 || size >= SMK_LABELLEN)
+		return -EINVAL;
+
+	if (strcmp(name, "current") != 0)
+		return -EINVAL;
+
+	newsmack = smk_import(value, size);
+	if (newsmack == NULL)
+		return -EINVAL;
+
+	p->security = newsmack;
+	return size;
+}
+
+/**
+ * smack_unix_stream_connect - Smack access on UDS
+ * @sock: one socket
+ * @other: the other socket
+ * @newsk: unused
+ *
+ * Return 0 if a subject with the smack of sock could access
+ * an object with the smack of other, otherwise an error code
+ */
+static int smack_unix_stream_connect(struct socket *sock,
+				     struct socket *other, struct sock *newsk)
+{
+	struct inode *sp = SOCK_INODE(sock);
+	struct inode *op = SOCK_INODE(other);
+
+	return smk_access(smk_of_inode(sp), smk_of_inode(op), MAY_READWRITE);
+}
+
+/**
+ * smack_unix_may_send - Smack access on UDS
+ * @sock: one socket
+ * @other: the other socket
+ *
+ * Return 0 if a subject with the smack of sock could access
+ * an object with the smack of other, otherwise an error code
+ */
+static int smack_unix_may_send(struct socket *sock, struct socket *other)
+{
+	struct inode *sp = SOCK_INODE(sock);
+	struct inode *op = SOCK_INODE(other);
+
+	return smk_access(smk_of_inode(sp), smk_of_inode(op), MAY_WRITE);
+}
+
+/**
+ * smack_from_secattr - Convert a netlabel mls_lvl/mls_cat pair to smack
+ * @sap: netlabel secattr
+ * @sip: where to put the result
+ *
+ * Copies a smack label into sip
+ */
+static void smack_from_secattr(struct netlbl_lsm_secattr *sap, char *sip)
+{
+	char smack[SMK_LABELLEN];
+	int pcat;
+
+	if ((sap->flags & NETLBL_SECATTR_MLS_LVL) == 0) {
+		/*
+		 * If there are flags but no level netlabel isn't
+		 * behaving the way we expect it to.
+		 *
+		 * Without guidance regarding the smack value
+		 * for the packet fall back on the network
+		 * ambient value.
+		 */
+		strncpy(sip, smack_net_ambient, SMK_MAXLEN);
+		return;
+	}
+	/*
+	 * Get the categories, if any
+	 */
+	memset(smack, '\0', SMK_LABELLEN);
+	if ((sap->flags & NETLBL_SECATTR_MLS_CAT) != 0)
+		for (pcat = -1;;) {
+			pcat = netlbl_secattr_catmap_walk(sap->mls_cat, pcat+1);
+			if (pcat < 0)
+				break;
+			smack_catset_bit(pcat, smack);
+		}
+	/*
+	 * If it is CIPSO using smack direct mapping
+	 * we are already done. WeeHee.
+	 */
+	if (sap->mls_lvl == smack_cipso_direct) {
+		memcpy(sip, smack, SMK_MAXLEN);
+		return;
+	}
+	/*
+	 * Look it up in the supplied table if it is not a direct mapping.
+	 */
+	smack_from_cipso(sap->mls_lvl, smack, sip);
+	return;
+}
+
+static int smack_socket_recvmsg(struct socket *sock, struct msghdr *msg,
+				int size, int flags)
+{
+	struct socket_smack *ssp = sock->sk->sk_security;
+
+	/*
+	 * If the depth is 0 no packets are queued.
+	 * If the depth is > 1 the "current" has been overwritten.
+	 */
+
+	if (ssp->smk_depth != 1)
+		ssp->smk_packet[0] = '\0';
+	if (ssp->smk_depth != 0)
+		ssp->smk_depth--;
+
+	return 0;
+}
+
+/**
+ * smack_socket_sock_rcv_skb - Smack packet delivery access check
+ * @sk: socket
+ * @skb: packet
+ *
+ * Returns 0 if the packet should be delivered, an error code otherwise
+ */
+static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
+{
+	struct netlbl_lsm_secattr secattr;
+	struct socket_smack *ssp = sk->sk_security;
+	char smack[SMK_LABELLEN];
+	int rc;
+
+	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
+		return 0;
+
+	/*
+	 * Translate what netlabel gave us.
+	 */
+	memset(smack, '\0', SMK_LABELLEN);
+	netlbl_secattr_init(&secattr);
+	rc = netlbl_skbuff_getattr(skb, &secattr);
+	if (rc == 0)
+		smack_from_secattr(&secattr, smack);
+	else
+		strncpy(smack, smack_net_ambient, SMK_MAXLEN);
+	netlbl_secattr_destroy(&secattr);
+	/*
+	 * Receiving a packet requires that the other end
+	 * be able to write here. Read access is not required.
+	 * This is the simplist possible security model
+	 * for networking.
+	 */
+	rc = smk_access(smack, ssp->smk_in, MAY_WRITE);
+	if (rc != 0)
+		return rc;
+
+	/*
+	 * If recv was called and there were no outstanding packets
+	 * this is the "current" Smack value to make available.
+	 */
+	if (ssp->smk_depth == 0)
+		strcpy(ssp->smk_packet, smack);
+	ssp->smk_depth++;
+
+	return 0;
+}
+
+/**
+ * smack_sock_graft - graft access state between two sockets
+ * @sk: fresh sock
+ * @parent: donor socket
+ *
+ * Sets the netlabel socket state on sk from parent
+ */
+static void smack_sock_graft(struct sock *sk, struct socket *parent)
+{
+	struct socket_smack *ssp;
+	struct netlbl_lsm_secattr secattr;
+	char smack[SMK_LABELLEN];
+	int rc;
+
+	if (sk == NULL || parent == NULL || parent->sk == NULL)
+		return;
+
+	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
+		return;
+
+	ssp = parent->sk->sk_security;
+
+	memset(smack, '\0', SMK_LABELLEN);
+	netlbl_secattr_init(&secattr);
+	rc = netlbl_sock_getattr(sk, &secattr);
+	if (rc == 0)
+		smack_from_secattr(&secattr, smack);
+	else
+		strncpy(smack, smack_known_huh.smk_known, SMK_MAXLEN);
+	netlbl_secattr_destroy(&secattr);
+
+	netlbl_secattr_init(&secattr);
+
+	smack_to_secattr(smack, &secattr);
+	if (secattr.flags != NETLBL_SECATTR_NONE)
+		rc = netlbl_sock_setattr(parent->sk, &secattr);
+	netlbl_secattr_destroy(&secattr);
+}
+
+/**
+ * smack_inet_conn_request - Smack access check on connect
+ * @sk: socket involved
+ * @skb: packet
+ * @req: unused
+ *
+ * Returns 0 if a task with the packet label could write to
+ * the socket, otherwise an error code
+ */
+static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
+				   struct request_sock *req)
+{
+	struct netlbl_lsm_secattr skb_secattr;
+	struct socket_smack *ssp = sk->sk_security;
+	char smack[SMK_LABELLEN];
+	int rc;
+
+	if (skb == NULL)
+		return -EACCES;
+
+	memset(smack, '\0', SMK_LABELLEN);
+	netlbl_secattr_init(&skb_secattr);
+	rc = netlbl_skbuff_getattr(skb, &skb_secattr);
+	if (rc == 0)
+		smack_from_secattr(&skb_secattr, smack);
+	else
+		strncpy(smack, smack_known_huh.smk_known, SMK_MAXLEN);
+	netlbl_secattr_destroy(&skb_secattr);
+	/*
+	 * Receiving a packet requires that the other end
+	 * be able to write here. Read access is not required.
+	 */
+	return smk_access(smack, ssp->smk_in, MAY_WRITE);
+}
+
+/*
+ * Key management security hooks
+ *
+ * Casey has not tested key support very heavily.
+ * The permission check is most likely too restrictive.
+ * If you care about keys please have a look.
+ */
+#ifdef CONFIG_KEYS
+
+/**
+ * smack_key_alloc - Set the key security blob
+ * @key: object
+ * @tsk: the task associated with the key
+ * @flags: unused
+ *
+ * No allocation required
+ *
+ * Returns 0
+ */
+static int smack_key_alloc(struct key *key, struct task_struct *tsk,
+			   unsigned long flags)
+{
+	key->security = tsk->security;
+	return 0;
+}
+
+/**
+ * smack_key_free - Clear the key security blob
+ * @key: the object
+ *
+ * Clear the blob pointer
+ */
+static void smack_key_free(struct key *key)
+{
+	key->security = NULL;
+}
+
+/*
+ * smack_key_permission - Smack access on a key
+ * @key_ref: gets to the object
+ * @context: task involved
+ * @perm: unused
+ *
+ * Return 0 if the task has read and write to the object,
+ * an error code otherwise
+ */
+static int smack_key_permission(key_ref_t key_ref,
+			        struct task_struct *context, key_perm_t perm)
+{
+	struct key *keyp;
+
+	keyp = key_ref_to_ptr(key_ref);
+	if (keyp == NULL)
+		return -EINVAL;
+	/*
+	 * If the key hasn't been initialized give it access so that
+	 * it may do so.
+	 */
+	if (keyp->security == NULL)
+		return 0;
+	/*
+	 * This should not occur
+	 */
+	if (context->security == NULL)
+		return -EACCES;
+
+	return smk_access(context->security, keyp->security, MAY_READWRITE);
+}
+#endif /* CONFIG_KEYS */
+
+static struct security_operations smack_ops = {
+	.ptrace = 			smack_ptrace,
+	.capget = 			cap_capget,
+	.capset_check = 		cap_capset_check,
+	.capset_set = 			cap_capset_set,
+	.capable = 			cap_capable,
+	/* .acct			No hook required */
+	/* .sysctl			No hook required */
+	/* .quotactl			No hook required */
+	/* .quota_on			No hook required */
+	.syslog = 			smack_syslog,
+	.settime = 			cap_settime,
+	.vm_enough_memory = 		cap_vm_enough_memory,
+
+	/* .bprm_alloc_security		No hook required */
+	/* .bprm_free_security		No hook required */
+	.bprm_apply_creds = 		cap_bprm_apply_creds,
+	/* .bprm_post_apply_creds	No hook required */
+	.bprm_set_security = 		cap_bprm_set_security,
+	/* .bprm_check_security		No hook required */
+	.bprm_secureexec = 		cap_bprm_secureexec,
+
+	.sb_alloc_security = 		smack_sb_alloc_security,
+	.sb_free_security = 		smack_sb_free_security,
+	.sb_copy_data = 		smack_sb_copy_data,
+	.sb_kern_mount = 		smack_sb_kern_mount,
+	.sb_statfs = 			smack_sb_statfs,
+	.sb_mount = 			smack_sb_mount,
+	/* .sb_check_sb			No hook required */
+	.sb_umount = 			smack_sb_umount,
+	/* .sb_umount_close		No hook required */
+	/* .sb_umount_busy		No hook required */
+	/* .sb_post_remount		No hook required */
+	/* .sb_post_mountroot		No hook required */
+	/* .sb_post_addmount		No hook required */
+	/* .sb_pivotroot		No hook required */
+	/* .sb_post_pivotroot		No hook required */
+
+	.inode_alloc_security = 	smack_inode_alloc_security,
+	.inode_free_security = 		smack_inode_free_security,
+	.inode_init_security = 		smack_inode_init_security,
+	.inode_create = 		smack_inode_create,
+	.inode_link = 			smack_inode_link,
+	.inode_unlink = 		smack_inode_unlink,
+	.inode_symlink = 		smack_inode_symlink,
+	.inode_mkdir = 			smack_inode_mkdir,
+	.inode_rmdir = 			smack_inode_rmdir,
+	.inode_mknod = 			smack_inode_mknod,
+	.inode_rename = 		smack_inode_rename,
+	.inode_readlink = 		smack_inode_readlink,
+	.inode_follow_link = 		smack_inode_follow_link,
+	.inode_permission = 		smack_inode_permission,
+	.inode_setattr = 		smack_inode_setattr,
+	.inode_getattr = 		smack_inode_getattr,
+	/* .inode_delete		No hook required */
+	.inode_setxattr = 		smack_inode_setxattr,
+	.inode_post_setxattr = 		smack_inode_post_setxattr,
+	.inode_getxattr = 		smack_inode_getxattr,
+	.inode_listxattr = 		smack_inode_listxattr,
+	.inode_removexattr = 		smack_inode_removexattr,
+	/* .inode_xattr_getsuffix	No hook required */
+	.inode_getsecurity = 		smack_inode_getsecurity,
+	.inode_setsecurity = 		smack_inode_setsecurity,
+	.inode_listsecurity = 		smack_inode_listsecurity,
+
+	.file_permission = 		smack_file_permission,
+	.file_alloc_security = 		smack_file_alloc_security,
+	.file_free_security = 		smack_file_free_security,
+	.file_ioctl = 			smack_file_ioctl,
+	/* .file_mmap			No hook required */
+	/* .file_mprotect		No hook required */
+	.file_lock = 			smack_file_lock,
+	.file_fcntl = 			smack_file_fcntl,
+	.file_set_fowner = 		smack_file_set_fowner,
+	.file_send_sigiotask = 		smack_file_send_sigiotask,
+	.file_receive = 		smack_file_receive,
+
+	/* .task_create			No hook required */
+	.task_alloc_security = 		smack_task_alloc_security,
+	.task_free_security = 		smack_task_free_security,
+	/* .task_setuid			No hook required */
+	.task_post_setuid =		cap_task_post_setuid,
+	/* .task_setgid			No hook required */
+	.task_setpgid = 		smack_task_setpgid,
+	.task_getpgid = 		smack_task_getpgid,
+	.task_getsid = 			smack_task_getsid,
+	.task_getsecid = 		smack_task_getsecid,
+	/* .task_setgroups		No hook required */
+	.task_setnice = 		smack_task_setnice,
+	.task_setioprio = 		smack_task_setioprio,
+	.task_getioprio = 		smack_task_getioprio,
+	/* .task_setrlimit		No hook required */
+	.task_setscheduler = 		smack_task_setscheduler,
+	.task_getscheduler = 		smack_task_getscheduler,
+	.task_movememory = 		smack_task_movememory,
+	.task_kill = 			smack_task_kill,
+	.task_wait = 			smack_task_wait,
+	/* .task_prctl			No hook required */
+	.task_reparent_to_init =	cap_task_reparent_to_init,
+	.task_to_inode = 		smack_task_to_inode,
+
+	.ipc_permission = 		smack_ipc_permission,
+
+	.msg_msg_alloc_security = 	smack_msg_msg_alloc_security,
+	.msg_msg_free_security = 	smack_msg_msg_free_security,
+
+	.msg_queue_alloc_security = 	smack_msg_queue_alloc_security,
+	.msg_queue_free_security = 	smack_msg_queue_free_security,
+	.msg_queue_associate = 		smack_msg_queue_associate,
+	.msg_queue_msgctl = 		smack_msg_queue_msgctl,
+	.msg_queue_msgsnd = 		smack_msg_queue_msgsnd,
+	.msg_queue_msgrcv = 		smack_msg_queue_msgrcv,
+
+	.shm_alloc_security = 		smack_shm_alloc_security,
+	.shm_free_security = 		smack_shm_free_security,
+	.shm_associate = 		smack_shm_associate,
+	.shm_shmctl = 			smack_shm_shmctl,
+	.shm_shmat = 			smack_shm_shmat,
+
+	.sem_alloc_security = 		smack_sem_alloc_security,
+	.sem_free_security = 		smack_sem_free_security,
+	.sem_associate = 		smack_sem_associate,
+	.sem_semctl = 			smack_sem_semctl,
+	.sem_semop = 			smack_sem_semop,
+
+	.netlink_send =			cap_netlink_send,
+	.netlink_recv = 		cap_netlink_recv,
+
+	/* .register_security		No hook required */
+	/* .unregister_security		No hook required */
+
+	.d_instantiate = 		smack_d_instantiate,
+
+	.getprocattr = 			smack_getprocattr,
+	.setprocattr = 			smack_setprocattr,
+	/* .secid_to_secctx		No hook required */
+	/* .release_secctx		No hook required */
+
+	.unix_stream_connect = 		smack_unix_stream_connect,
+	.unix_may_send = 		smack_unix_may_send,
+
+	/* .socket_create 		No hook required */
+	.socket_post_create = 		smack_socket_post_create,
+	/* .socket_bind 		No hook required */
+	/* .socket_connect 		No hook required */
+	/* .socket_listen 		No hook required */
+	/* .socket_accept 		No hook required */
+	/* .socket_post_accept 		No hook required */
+	/* .socket_sendmsg 		No hook required */
+	.socket_recvmsg =		smack_socket_recvmsg,
+	/* .socket_getsockname		No hook required */
+	/* .socket_getpeername		No hook required */
+	/* .socket_getsockopt		No hook required */
+	/* .socket_setsockopt		No hook required */
+	/* .socket_shutdown		No hook required */
+	.socket_sock_rcv_skb = 		smack_socket_sock_rcv_skb,
+	/* .socket_getpeersec_stream	No hook required */
+	/* .socket_getpeersec_dgram	No hook required */
+	.sk_alloc_security = 		smack_sk_alloc_security,
+	.sk_free_security = 		smack_sk_free_security,
+	/* .sk_clone_security 		No hook required */
+	/* .sk_getsecid 		No hook required */
+	.sock_graft = 			smack_sock_graft,
+	.inet_conn_request = 		smack_inet_conn_request,
+	/* .inet_csk_clone		No hook required */
+	/* .inet_conn_established	No hook required */
+
+	/* .req_classify_flow 		No hook required */
+	/* .xfrm_policy_alloc_security	no xfrm for smack */
+	/* .xfrm_policy_clone_security	no xfrm for smack */
+	/* .xfrm_policy_free_security	no xfrm for smack */
+	/* .xfrm_policy_delete_security	no xfrm for smack */
+	/* .xfrm_state_alloc_security	no xfrm for smack */
+	/* .xfrm_state_free_security	no xfrm for smack */
+	/* .xfrm_state_delete_security	no xfrm for smack */
+	/* .xfrm_policy_lookup		no xfrm for smack */
+	/* .xfrm_state_pol_flow_match	no xfrm for smack */
+	/* .xfrm_decode_session		no xfrm for smack */
+
+ /* key management security hooks */
+#ifdef CONFIG_KEYS
+	.key_alloc = 			smack_key_alloc,
+	.key_free = 			smack_key_free,
+	.key_permission = 		smack_key_permission,
+#endif /* CONFIG_KEYS */
+
+};
+
+DEFINE_MUTEX(smack_list_lock);
+DEFINE_MUTEX(smack_known_lock);
+
+/**
+ * smack_init - initialize the smack system
+ *
+ * Returns 0
+ */
+static __init int smack_init(void)
+{
+	printk(KERN_INFO "Smack:  Initializing.\n");
+
+	/*
+	 * Set the security state for the initial task.
+	 */
+	current->security = &smack_known_floor.smk_known;
+
+	/*
+ 	 * Initialize locks
+ 	 */
+	spin_lock_init(&smack_known_unset.smk_cipsolock);
+	spin_lock_init(&smack_known_huh.smk_cipsolock);
+	spin_lock_init(&smack_known_hat.smk_cipsolock);
+	spin_lock_init(&smack_known_star.smk_cipsolock);
+	spin_lock_init(&smack_known_floor.smk_cipsolock);
+	spin_lock_init(&smack_known_invalid.smk_cipsolock);
+
+	mutex_init(&smack_known_lock);
+	mutex_init(&smack_list_lock);
+
+	/*
+	 * Register with LSM
+	 */
+	if (register_security(&smack_ops))
+		panic("smack: Unable to register with kernel.\n");
+
+	return 0;
+}
+
+/*
+ * Smack requires early initialization in order to label
+ * all processes and objects when they are created.
+ */
+security_initcall(smack_init);
+
_

Patches currently in -mm which might be from casey@schaufler-ca.com are

ifdef-struct-task_structsecurity.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
file-caps-clean-up-for-linux-capabilityh.patch
capabilityh-remove-include-of-currenth.patch
file-capabilities-clear-fcaps-on-inode-change.patch
capabilities-reset-current-pdeath_signal-when-increasing-capabilities.patch
smack-simplified-mandatory-access-control-kernel.patch
