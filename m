From: akpm@linux-foundation.org
Subject: - smack-simplified-mandatory-access-control-kernel.patch removed from -mm tree
Date: Mon, 12 Nov 2007 21:31:57 -0800
Message-ID: <200711130538.lAD5csmq028382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33498 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839AbXKMFjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Nov 2007 00:39:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, paul.moore@hp.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     Smack: Simplified Mandatory Access Control Kernel
has been removed from the -mm tree.  Its filename was
     smack-simplified-mandatory-access-control-kernel.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Smack: Simplified Mandatory Access Control Kernel
From: Casey Schaufler <casey@schaufler-ca.com>

Smack is the Simplified Mandatory Access Control Kernel.

Smack implements mandatory access control (MAC) using labels attached to tasks
and data containers, including files, SVIPC, and other tasks.  Smack is a
kernel based scheme that requires an absolute minimum of application support
and a very small amount of configuration data.

Smack uses extended attributes and
provides a set of general mount options, borrowing technics used
elsewhere. Smack uses netlabel for CIPSO labeling. Smack provides
a pseudo-filesystem smackfs that is used for manipulation of
system Smack attributes.

The patch, patches for ls and sshd, a README, a startup script,
and x86 binaries for ls and sshd are also available on

    http://www.schaufler-ca.com

This version has been tested with 2.6.24-rc2. Development has been
done using Fedora Core 7 in a virtual machine environment and on an
old Sony laptop. The netlabel api patch has changed from 2.6.24-rc1
because there were other changes in that code.

Smack provides mandatory access controls based on the label attached
to a task and the label attached to the object it is attempting to
access. Smack labels are deliberately short (1-23 characters) text
strings. Single character labels using special characters are reserved
for system use. The only operation applied to Smack labels is equality
comparison. No wildcards or expressions, regular or otherwise, are
used. Smack labels are composed of printable characters and may not
include "/".

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

Rules may be explicitly defined by writing subject,object,access
triples to /smack/load. The program smackload should always
be used to ensure that the data is formatted correctly when
sent to the kernel.

Smack rule sets can be easily defined that describe Bell&LaPadula
sensitivity, Biba integrity, and a variety of interesting
configurations. Smack rule sets can be modified on the fly to
accomodate changes in the operating environment or even the time
of day.

Some practical use cases:

Hierarchical levels. The less common of the two usual uses
for MLS systems is to define hierarchical levels, often
unclassified, confidential, secret, and so on. To set up smack
to support this, these rules could be defined:

   C        Unclass rx
   S        C       rx
   S        Unclass rx
   TS       S       rx
   TS       C       rx
   TS       Unclass rx

A TS process can read S, C, and Unclass data, but cannot write it.
An S process can read C and Unclass. Note that specifying that
TS can read S and S can read C does not imply TS can read C, it
has to be explicitly stated.

Non-hierarchical categories. This is the more common of the
usual uses for an MLS system. Since the default rule is that a
subject cannot access an object with a different label no
access rules are required to implement compartmentalization.

A case that the Bell & LaPadula policy does not allow is demonstrated
with this Smack access rule:

A case that Bell&LaPadula does not allow that Smack does:

    ESPN    ABC   r
    ABC     ESPN  r

On my portable video device I have two applications, one that
shows ABC programming and the other ESPN programming. ESPN wants
to show me sport stories that show up as news, and ABC will
only provide minimal information about a sports story if ESPN
is covering it. Each side can look at the other's info, neither
can change the other. Neither can see what FOX is up to, which
is just as well all things considered.

Another case that I especially like:

    SatData Guard   w
    Guard   Publish w

A program running with the Guard label opens a UDP socket and
accepts messages sent by a program running with a SatData label.
The Guard program inspects the message to ensure it is wholesome
and if it is sends it to a program running with the Publish label.
This program then puts the information passed in an appropriate
place. Note that the Guard program cannot write to a Publish
file system object because file system semanitic require read as
well as write.

The four cases (categories, levels, mutual read, guardbox) here
are all quite real, and problems I've been asked to solve over
the years. The first two are easy to do with traditonal MLS systems
while the last two you can't without invoking privilege, at least
for a while.

Special Thanks:
  - Joshua Brindle, for reporting his experiance with ps -AZ.
  - Ahmed Darwish, again for code I didn't have to write

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: Paul Moore <paul.moore@hp.com>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Smack.txt       |  493 ++++++
 security/Kconfig              |    1 
 security/Makefile             |    2 
 security/smack/Kconfig        |   10 
 security/smack/Makefile       |    7 
 security/smack/smack.h        |  230 ++
 security/smack/smack_access.c |  353 ++++
 security/smack/smack_lsm.c    | 2530 ++++++++++++++++++++++++++++++++
 security/smack/smackfs.c      |  975 ++++++++++++
 9 files changed, 4601 insertions(+)

diff -puN /dev/null Documentation/Smack.txt
--- /dev/null
+++ a/Documentation/Smack.txt
@@ -0,0 +1,493 @@
+
+
+    "Good for you, you've decided to clean the elevator!"
+    - The Elevator, from Dark Star
+
+Smack is the the Simplified Mandatory Access Control Kernel.
+Smack is a kernel based implementation of mandatory access
+control that includes simplicity in its primary design goals.
+
+Smack is not the only Mandatory Access Control scheme
+available for Linux. Those new to Mandatory Access Control
+are encouraged to compare Smack with the other mechanisms
+available to determine which is best suited to the problem
+at hand.
+
+Smack consists of three major components:
+    - The kernel
+    - A start-up script and a few modified applications
+    - Configuration data
+
+The kernel component of Smack is implemented as a Linux
+Security Modules (LSM) module. It requires netlabel and
+works best with file systems that support extended attributes,
+although xattr support is not strictly required.
+It is safe to run a Smack kernel under a "vanilla" distribution.
+Smack kernels use the CIPSO IP option. Some network
+configurations are intolerant of IP options and can impede
+access to systems that use them as Smack does.
+
+The startup script etc-init.d-smack should be installed
+in /etc/init.d/smack and should be invoked early in the
+start-up process. On Fedora rc5.d/S02smack is recommended.
+This script ensures that certain devices have the correct
+Smack attributes and loads the Smack configuration if
+any is defined. This script invokes two programs that
+ensure configuration data is properly formatted. These
+programs are /usr/sbin/smackload and /usr/sin/smackcipso.
+The system will run just fine without these programs,
+but it will be difficult to set access rules properly.
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
+Look for additional programs on http://schaufler-ca.com
+
+From the Smack Whitepaper:
+
+The Simplified Mandatory Access Control Kernel
+
+Casey Schaufler
+casey@schaufler-ca.com
+
+Mandatory Access Control
+
+Computer systems employ a variety of schemes to constrain how information is
+shared among the people and services using the machine. Some of these schemes
+allow the program or user to decide what other programs or users are allowed
+access to pieces of data. These schemes are called discretionary access
+control mechanisms because the access control is specified at the discretion
+of the user. Other schemes do not leave the decision regarding what a user or
+program can access up to users or programs. These schemes are called mandatory
+access control mechanisms because you don't have a choice regarding the users
+or programs that have access to pieces of data.
+
+Bell & LaPadula
+
+From the middle of the 1980's until the turn of the century Mandatory Access
+Control (MAC) was very closely associated with the Bell & LaPadula security
+model, a mathematical description of the United States Department of Defense
+policy for marking paper documents. MAC in this form enjoyed a following
+within the Capital Beltway and Scandinavian supercomputer centers but was
+often sited as failing to address general needs.
+
+Domain Type Enforcement
+
+Around the turn of the century Domain Type Enforcement (DTE) became popular.
+This scheme organizes users, programs, and data into domains that are
+protected from each other. This scheme has been widely deployed as a component
+of popular Linux distributions. The administrative overhead required to
+maintain this scheme and the detailed understanding of the whole system
+necessary to provide a secure domain mapping leads to the scheme being
+disabled or used in limited ways in the majority of cases.
+
+Smack
+
+Smack is a Mandatory Access Control mechanism designed to provide useful MAC
+while avoiding the pitfalls of its predecessors. The limitations of Bell &
+LaPadula are addressed by providing a scheme whereby access can be controlled
+according to the requirements of the system and its purpose rather than those
+imposed by an arcane government policy. The complexity of Domain Type
+Enforcement and avoided by defining access controls in terms of the access
+modes already in use.
+
+Smack Terminology
+
+The jargon used to talk about Smack will be familiar to those who have dealt
+with other MAC systems and shouldn't be too difficult for the uninitiated to
+pick up. There are four terms that are used in a specific way and that are
+especially important:
+
+	Subject: A subject is an active entity on the computer system.
+	On Smack a subject is a task, which is in turn the basic unit
+	of execution.
+
+	Object: An object is a passive entity on the computer system.
+	On Smack files of all types, IPC, and tasks can be objects.
+
+	Access: Any attempt by a subject to put information into or get
+	information from an object is an access.
+
+	Label: Data that identifies the Mandatory Access Control
+	characteristics of a subject or an object.
+
+These definitions are consistent with the traditional use in the security
+community. There are also some terms from Linux that are likely to crop up:
+
+	Capability: A task that possesses a capability has permission to
+	violate an aspect of the system security policy, as identified by
+	the specific capability. A task that possesses one or more
+	capabilities is a privileged task, whereas a task with no
+	capabilities is an unprivileged task.
+
+	Privilege: A task that is allowed to violate the system security
+	policy is said to have privilege. As of this writing a task can
+	have privilege either by possessing capabilities or by having an
+	effective user of root.
+
+Smack Basics
+
+Smack is an extension to a Linux system. It enforces additional restrictions
+on what subjects can access which objects, based on the labels attached to
+each of the subject and the object.
+
+Labels
+
+Smack labels are ASCII character strings, one to twenty-three characters in
+length. Single character labels using special characters, that being anything
+other than a letter or digit, are reserved for use by the Smack development
+team. Smack labels are unstructured, case sensitive, and the only operation
+ever performed on them is comparison for equality. Smack labels cannot
+contain unprintable characters or the "/" (slash) character.
+
+There are some predefined labels:
+
+	_ Pronounced "floor", a single underscore character.
+	^ Pronounced "hat", a single circumflex character.
+	* Pronounced "star", a single asterisk character.
+	? Pronounced "huh", a single question mark character.
+
+Every task on a Smack system is assigned a label. System tasks, such as
+init(8) and systems daemons, are run with the floor ("_") label. User tasks
+are assigned labels according to the specification found in the
+/etc/smack/user configuration file.
+
+Access Rules
+
+Smack uses the traditional access modes of Linux. These modes are read,
+execute, write, and occasionally append. There are a few cases where the
+access mode may not be obvious. These include:
+
+	Signals: A signal is a write operation from the subject task to
+	the object task.
+	Internet Domain IPC: Transmission of a packet is considered a
+	write operation from the source task to the destination task.
+
+Smack restricts access based on the label attached to a subject and the label
+attached to the object it is trying to access. The rules enforced are, in
+order:
+
+	1. Any access requested by a task labeled "*" is denied.
+	2. A read or execute access requested by a task labeled "^"
+	   is permitted.
+	3. A read or execute access requested on an object labeled "_"
+	   is permitted.
+	4. Any access requested on an object labeled "*" is permitted.
+	5. Any access requested by a task on an object with the same
+	   label is permitted.
+	6. Any access requested that is explicitly defined in the loaded
+	   rule set is permitted.
+	7. Any other access is denied.
+
+Smack Access Rules
+
+With the isolation provided by Smack access separation is simple. There are
+many interesting cases where limited access by subjects to objects with
+different labels is desired. One example is the familiar spy model of
+sensitivity, where a scientist working on a highly classified project would be
+able to read documents of lower classifications and anything she writes will
+be "born" highly classified. To accommodate such schemes Smack includes a
+mechanism for specifying rules allowing access between labels.
+
+Access Rule Format
+
+The format of an access rule is:
+
+	subject-label object-label access
+
+Where subject-label is the Smack label of the task, object-label is the Smack
+label of the thing being accessed, and access is a string specifying the sort
+of access allowed. The Smack labels are limited to 23 characters. The access
+specification is searched for letters that describe access modes:
+
+	a: indicates that append access should be granted.
+	r: indicates that read access should be granted.
+	w: indicates that write access should be granted.
+	x: indicates that execute access should be granted.
+
+Uppercase values for the specification letters are allowed as well.
+Access mode specifications can be in any order. Examples of acceptable rules
+are:
+
+	TopSecret Secret  rx
+	Secret    Unclass R
+	Manager   Game    x
+	User      HR      w
+	New       Old     rRrRr
+	Closed    Off     -
+
+Examples of unacceptable rules are:
+
+	Top Secret Secret     rx
+	Ace        Ace        r
+	Odd        spells     waxbeans
+
+Spaces are not allowed in labels. Since a subject always has access to files
+with the same label specifying a rule for that case is pointless. Only
+valid letters (rwxaRWXA) and the dash ('-') character are allowed in
+access specifications. The dash is a placeholder, so "a-r" is the same
+as "ar". A lone dash is used to specify that no access should be allowed.
+
+Applying Access Rules
+
+The developers of Linux rarely define new sorts of things, usually importing
+schemes and concepts from other systems. Most often, the other systems are
+variants of Unix. Unix has many endearing properties, but consistency of
+access control models is not one of them. Smack strives to treat accesses as
+uniformly as is sensible while keeping with the spirit of the underlying
+mechanism.
+
+File system objects including files, directories, named pipes, symbolic links,
+and devices require access permissions that closely match those used by mode
+bit access. To open a file for reading read access is required on the file. To
+search a directory requires execute access. Creating a file with write access
+requires both read and write access on the containing directory. Deleting a
+file requires read and write access to the file and to the containing
+directory. It is possible that a user may be able to see that a file exists
+but not any of its attributes by the circumstance of having read access to the
+containing directory but not to the differently labeled file. This is an
+artifact of the file name being data in the directory, not a part of the file.
+
+IPC objects, message queues, semaphore sets, and memory segments exist in flat
+namespaces and access requests are only required to match the object in
+question.
+
+Process objects reflect tasks on the system and the Smack label used to access
+them is the same Smack label that the task would use for its own access
+attempts. Sending a signal via the kill() system call is a write operation
+from the signaler to the recipient. Debugging a process requires both reading
+and writing. Creating a new task is an internal operation that results in two
+tasks with identical Smack labels and requires no access checks.
+
+Sockets are data structures attached to processes and sending a packet from
+one process to another requires that the sender have write access to the
+receiver. The receiver is not required to have read access to the sender.
+
+Setting Access Rules
+
+The configuration file /etc/smack/accesses contains the rules to be set at
+system startup. The contents are written to the special file /smack/load.
+Rules can be written to /smack/load at any time and take effect immediately.
+For any pair of subject and object labels there can be only one rule, with the
+most recently specified overriding any earlier specification.
+
+The program smackload is provided to ensure data is formatted
+properly when written to /smack/load. This program reads lines
+of the form
+
+    subjectlabel objectlabel mode.
+
+Task Attribute
+
+The Smack label of a process can be read from /proc/<pid>/attr/current. A
+process can read its own Smack label from /proc/self/attr/current. A
+privileged process can change its own Smack label by writing to
+/proc/self/attr/current but not the label of another process.
+
+File Attribute
+
+The Smack label of a filesystem object is stored as an extended attribute
+named SMACK64 on the file. This attribute is in the security namespace. It can
+only be changed by a process with privilege.
+
+Privilege
+
+A process with CAP_MAC_OVERRIDE is privileged.
+
+Smack Networking
+
+As mentioned before, Smack enforces access control on network protocol
+transmissions. Every packet sent by a Smack process is tagged with its Smack
+label. This is done by adding a CIPSO tag to the header of the IP packet. Each
+packet received is expected to have a CIPSO tag that identifies the label and
+if it lacks such a tag the network ambient label is assumed. Before the packet
+is delivered a check is made to determine that a subject with the label on the
+packet has write access to the receiving process and if that is not the case
+the packet is dropped.
+
+CIPSO Configuration
+
+It is normally unnecessary to specify the CIPSO configuration. The default
+values used by the system handle all internal cases. Smack will compose CIPSO
+label values to match the Smack labels being used without administrative
+intervention. Unlabeled packets that come into the system will be given the
+ambient label.
+
+Smack requires configuration in the case where packets from a system that is
+not smack that speaks CIPSO may be encountered. Usually this will be a Trusted
+Solaris system, but there are other, less widely deployed systems out there.
+CIPSO provides 3 important values, a Domain Of Interpretation (DOI), a level,
+and a category set with each packet. The DOI is intended to identify a group
+of systems that use compatible labeling schemes, and the DOI specified on the
+smack system must match that of the remote system or packets will be
+discarded. The DOI is 3 by default. The value can be read from /smack/doi and
+can be changed by writing to /smack/doi.
+
+The label and category set are mapped to a Smack label as defined in
+/etc/smack/cipso.
+
+A Smack/CIPSO mapping has the form:
+
+	smack level [category [category]*]
+
+Smack does not expect the level or category sets to be related in any
+particular way and does not assume or assign accesses based on them. Some
+examples of mappings:
+
+	TopSecret 7
+	TS:A,B    7 1 2
+	SecBDE    5 2 4 6
+	RAFTERS   7 12 26
+
+The ":" and "," characters are permitted in a Smack label but have no special
+meaning.
+
+The mapping of Smack labels to CIPSO values is defined by writing to
+/smack/cipso. Again, the format of data written to this special file
+is highly restrictive, so the program smackcipso is provided to
+ensure the writes are done properly. This program takes mappings
+on the standard input and sends them to /smack/cipso properly.
+
+In addition to explicit mappings Smack supports direct CIPSO mappings. One
+CIPSO level is used to indicate that the category set passed in the packet is
+in fact an encoding of the Smack label. The level used is 250 by default. The
+value can be read from /smack/direct and changed by writing to /smack/direct.
+
+Socket Attributes
+
+There are two attributes that are associated with sockets. These attributes
+can only be set by privileged tasks, but any task can read them for their own
+sockets.
+
+	SMACK64IPIN: The Smack label of the task object. A privileged
+	program that will enforce policy may set this to the star label.
+
+	SMACK64IPOUT: The Smack label transmitted with outgoing packets.
+	A privileged program may set this to match the label of another
+	task with which it hopes to communicate.
+
+Writing Applications for Smack
+
+There are three sorts of applications that will run on a Smack system. How an
+application interacts with Smack will determine what it will have to do to
+work properly under Smack.
+
+Smack Ignorant Applications
+
+By far the majority of applications have no reason whatever to care about the
+unique properties of Smack. Since invoking a program has no impact on the
+Smack label associated with the process the only concern likely to arise is
+whether the process has execute access to the program.
+
+Smack Relevant Applications
+
+Some programs can be improved by teaching them about Smack, but do not make
+any security decisions themselves. The utility ls(1) is one example of such a
+program.
+
+Smack Enforcing Applications
+
+These are special programs that not only know about Smack, but participate in
+the enforcement of system policy. In most cases these are the programs that
+set up user sessions. There are also network services that provide information
+to processes running with various labels.
+
+File System Interfaces
+
+Smack maintains labels on file system objects using extended attributes. The
+Smack label of a file, directory, or other file system object can be obtained
+using getxattr(2).
+
+	len = getxattr("/", "security.SMACK64", value, sizeof (value));
+
+will put the Smack label of the root directory into value. A privileged
+process can set the Smack label of a file system object with setxattr(2).
+
+	len = strlen("Rubble");
+	rc = setxattr("/foo", "security.SMACK64", "Rubble", len, 0);
+
+will set the Smack label of /foo to "Rubble" if the program has appropriate
+privilege.
+
+Socket Interfaces
+
+The socket attributes can be read using fgetxattr(2).
+
+A privileged process can set the Smack label of outgoing packets with
+fsetxattr(2).
+
+	len = strlen("Rubble");
+	rc = fsetxattr(fd, "security.SMACK64IPOUT", "Rubble", len, 0);
+
+will set the Smack label "Rubble" on packets going out from the socket if the
+program has appropriate privilege.
+
+	rc = fsetxattr(fd, "security.SMACK64IPIN, "*", strlen("*"), 0);
+
+will set the Smack label "*" as the object label against which incoming
+packets will be checked if the program has appropriate privilege.
+
+Administration
+
+Smack supports some mount options:
+
+	smackfsdef=label: specifies the label to give files that lack
+	the Smack label extended attribute.
+
+	smackfsroot=label: specifies the label to assign the root of the
+	file system if it lacks the Smack extended attribute.
+
+	smackfshat=label: specifies a label that must have read access to
+	all labels set on the filesystem. Not yet enforced.
+
+	smackfsfloor=label: specifies a label to which all labels set on the
+	filesystem must have read access. Not yet enforced.
+
+These mount options apply to all file system types.
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
@@ -0,0 +1,7 @@
+#
+# Makefile for the SMACK LSM
+#
+
+obj-$(CONFIG_SECURITY_SMACK) := smack.o
+
+smack-y := smack_lsm.o smack_access.o smackfs.o
diff -puN /dev/null security/smack/smack.h
--- /dev/null
+++ a/security/smack/smack.h
@@ -0,0 +1,230 @@
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
+/*
+ * How many kinds of access are there?
+ * Here's your answer.
+ */
+#define SMK_ACCESSDASH	'-'
+#define SMK_ACCESSLOW	"rwxa"
+#define SMK_ACCESSKINDS	(sizeof(SMK_ACCESSLOW) - 1)
+
+struct superblock_smack {
+	char		*smk_root;
+	char		*smk_floor;
+	char		*smk_hat;
+	char		*smk_default;
+	int		smk_initialized;
+	spinlock_t	smk_sblock;	/* for initialization */
+};
+
+struct socket_smack {
+	char		*smk_out;	/* outbound label */
+	char		*smk_in;	/* inbound label */
+	char		smk_packet[SMK_LABELLEN];
+	int		smk_depth;
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
+	spinlock_t		smk_cipsolock; /* for changing cipso map */
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
+#define SMACK_CIPSO_MAXCATVAL		63	/* Bigger gets harder */
+#define SMACK_CIPSO_MAXLEVEL            255     /* CIPSO 2.2 standard */
+#define SMACK_CIPSO_MAXCATNUM           239     /* CIPSO 2.2 standard */
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
+ * Shared data.
+ */
+extern int smack_cipso_direct;
+extern int smack_net_nltype;
+extern char *smack_net_ambient;
+
+extern struct smack_known *smack_known;
+extern struct mutex smack_known_lock;
+extern struct smack_known smack_known_floor;
+extern struct smack_known smack_known_hat;
+extern struct smack_known smack_known_huh;
+extern struct smack_known smack_known_invalid;
+extern struct smack_known smack_known_star;
+extern struct smack_known smack_known_unset;
+
+extern struct smk_list_entry *smack_list;
+extern struct mutex smack_list_lock;
+extern struct mutex smack_cipso_lock;
+
+/*
+ * Stricly for CIPSO level manipulation.
+ * Set the category bit number in a smack label sized buffer.
+ */
+static inline void smack_catset_bit(int cat, char *catsetp)
+{
+	if (cat > SMK_LABELLEN * 8)
+		return;
+
+	catsetp[(cat - 1) / 8] |= 0x80 >> ((cat - 1) % 8);
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
diff -puN /dev/null security/smack/smack_access.c
--- /dev/null
+++ a/security/smack/smack_access.c
@@ -0,0 +1,353 @@
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
+		else if (i >= len || string[i] > '~' || string[i] <= ' ' ||
+			 string[i] == '/') {
+			smack[i] = '\0';
+			found = 1;
+		} else
+			smack[i] = string[i];
+	}
+
+	if (smack[0] == '\0')
+		return NULL;
+
+	mutex_lock(&smack_known_lock);
+
+	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
+		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0)
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
+			/*
+			 * Make sure that the entry is actually
+			 * filled before putting it on the list.
+			 */
+			smp_mb();
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
+/**
+ * smack_to_secid - find the secid associated with a Smack label
+ * @smack: the Smack label
+ *
+ * Returns the appropriate secid if there is one,
+ * otherwise 0
+ */
+u32 smack_to_secid(const char *smack)
+{
+	struct smack_known *skp;
+
+	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
+		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0)
+			return skp->smk_secid;
+	return 0;
+}
+
+/**
+ * smack_from_cipso - find the Smack label associated with a CIPSO option
+ * @level: Bell & LaPadula level from the network
+ * @cp: Bell & LaPadula categories from the network
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
+void smack_from_cipso(u32 level, char *cp, char *result)
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
+		    memcmp(kp->smk_cipso->smk_catset, cp, SMK_LABELLEN) == 0)
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
+	struct smack_known *kp;
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
diff -puN /dev/null security/smack/smack_lsm.c
--- /dev/null
+++ a/security/smack/smack_lsm.c
@@ -0,0 +1,2530 @@
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
+#include <linux/pipe_fs_i.h>
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
+#define TMPFS_MAGIC		0x01021994
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
+	spin_lock_init(&sbsp->smk_sblock);
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
+	struct dentry *root = sb->s_root;
+	struct inode *inode = root->d_inode;
+	struct superblock_smack *sp = sb->s_security;
+	struct inode_smack *isp;
+	char *op;
+	char *commap;
+	char *nsp;
+
+	spin_lock(&sp->smk_sblock);
+	if (sp->smk_initialized != 0) {
+		spin_unlock(&sp->smk_sblock);
+		return 0;
+	}
+	sp->smk_initialized = 1;
+	spin_unlock(&sp->smk_sblock);
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
+		} else if (strncmp(op, SMK_FSDEFAULT,
+				   strlen(SMK_FSDEFAULT)) == 0) {
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
+	struct superblock_smack *sbp = dentry->d_sb->s_security;
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
+	struct superblock_smack *sbp = nd->mnt->mnt_sb->s_security;
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
+				     char **name, void **value, size_t *len)
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
+ * @old_dentry: the existing object
+ * @dir: unused
+ * @new_dentry: the new object
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
+			    struct dentry *new_dentry)
+{
+	int rc;
+	char *isp;
+
+	isp = smk_of_inode(old_dentry->d_inode);
+	rc = smk_curacc(isp, MAY_WRITE);
+
+	if (rc == 0 && new_dentry->d_inode != NULL) {
+		isp = smk_of_inode(new_dentry->d_inode);
+		rc = smk_curacc(isp, MAY_WRITE);
+	}
+
+	return rc;
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
+ * smack_inode_rmdir - Smack check on directory deletion
+ * @dir: containing directory object
+ * @dentry: directory to unlink
+ *
+ * Returns 0 if current can write the containing directory
+ * and the directory, error code otherwise
+ */
+static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	int rc;
+
+	/*
+	 * You need write access to the thing you're removing
+	 */
+	rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
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
+	char *isp;
+
+	isp = smk_of_inode(old_dentry->d_inode);
+	rc = smk_curacc(isp, MAY_READWRITE);
+
+	if (rc == 0 && new_dentry->d_inode != NULL) {
+		isp = smk_of_inode(new_dentry->d_inode);
+		rc = smk_curacc(isp, MAY_READWRITE);
+	}
+
+	return rc;
+}
+
+/**
+ * smack_inode_permission - Smack version of permission()
+ * @inode: the inode in question
+ * @mask: the access requested
+ * @nd: unused
+ *
+ * This is the important Smack hook.
+ *
+ * Returns 0 if access is permitted, -EACCES otherwise
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
+ * @iattr: for the force flag
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	/*
+	 * Need to allow for clearing the setuid bit.
+	 */
+	if (iattr->ia_valid & ATTR_FORCE)
+		return 0;
+
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
+ * @name: name of the attribute
+ * @value: unused
+ * @size: unused
+ * @flags: unused
+ *
+ * This protects the Smack attribute explicitly.
+ *
+ * Returns 0 if access is permitted, an error code otherwise
+ */
+static int smack_inode_setxattr(struct dentry *dentry, char *name,
+				void *value, size_t size, int flags)
+{
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
+		!__capable(current, CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
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
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
+		!__capable(current, CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
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
+static int smack_inode_getsecurity(const struct inode *inode,
+				   const char *name, void *buffer,
+				   size_t size, int err)
+{
+	struct socket_smack *ssp;
+	struct socket *sock;
+	struct super_block *sbp;
+	struct inode *ip = (struct inode *)inode;
+	char *isp;
+	int ilen;
+	int rc = 0;
+
+	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
+		isp = smk_of_inode(inode);
+		ilen = strlen(isp) + 1;
+		if (ilen > size)
+			return -EINVAL;
+		strncpy(buffer, isp, ilen);
+		return ilen;
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
+	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
+		isp = ssp->smk_in;
+	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
+		isp = ssp->smk_out;
+	else
+		return -EOPNOTSUPP;
+
+	ilen = strlen(isp) + 1;
+	if (ilen > size)
+		rc = -EINVAL;
+	if (rc == 0) {
+		strncpy(buffer, isp, ilen);
+		rc = ilen;
+	}
+
+	return rc;
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
+	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
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
+/*
+ * File Hooks
+ */
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
+	file = (struct file *)((long)fown - offsetof(struct file, f_owner));
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
+ * Task hooks
+ */
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
+ * smack_task_kill - Smack check on signal delivery
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
+	 * Special cases where signals really ought to go through
+	 * in spite of policy. Stephen Smalley suggests it may
+	 * make sense to change the caller so that it doesn't
+	 * bother with the LSM hook in these cases.
+	 */
+	if (info != SEND_SIG_NOINFO &&
+	    (is_si_special(info) || SI_FROMKERNEL(info)))
+		return 0;
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
+ * Assign Smack pointers to current
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
+	int byte;
+
+	if (catset == 0)
+		return;
+
+	sap->flags |= NETLBL_SECATTR_MLS_CAT;
+	sap->mls_cat = netlbl_secattr_catmap_alloc(GFP_ATOMIC);
+	sap->mls_cat->startbit = 0;
+
+	for (cat = 1, cp = catset, byte = 0; byte < SMK_LABELLEN; cp++, byte++)
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
+	struct socket_smack *ssp = sk->sk_security;
+	struct netlbl_lsm_secattr secattr;
+	int rc = 0;
+
+	netlbl_secattr_init(&secattr);
+	smack_to_secattr(ssp->smk_out, &secattr);
+	if (secattr.flags != NETLBL_SECATTR_NONE)
+		rc = netlbl_sock_setattr(sk, &secattr);
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
+ * @kern: unused
+ *
+ * Sets the netlabel information on the socket
+ *
+ * Returns 0 on success, and error code otherwise
+ */
+static int smack_socket_post_create(struct socket *sock, int family,
+				    int type, int protocol, int kern)
+{
+	if (family != PF_INET)
+		return 0;
+	/*
+	 * Set the outbound netlbl.
+	 */
+	return smack_netlabel(sock->sk);
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
+	switch (cmd) {
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
+	switch (cmd) {
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
+static int smack_sem_semop(struct sem_array *sma, struct sembuf *sops,
+			   unsigned nsops, int alter)
+{
+	char *ssp = smack_of_sem(sma);
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
+	switch (cmd) {
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
+ * smack_d_instantiate - Make sure the blob is correct on an inode
+ * @opt_dentry: unused
+ * @inode: the object
+ *
+ * Set the inode's security blob if it hasn't been done already.
+ */
+static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
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
+	cp = kstrdup(p->security, GFP_KERNEL);
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
+	return smk_access(smack, ssp->smk_in, MAY_WRITE);
+}
+
+/**
+ * smack_socket_getpeersec_stream - pull in packet label
+ * @sock: the socket
+ * @optval: user's destination
+ * @optlen: size thereof
+ * @len: max thereoe
+ *
+ * returns zero on success, an error code otherwise
+ */
+static int smack_socket_getpeersec_stream(struct socket *sock,
+					  char __user *optval,
+					  int __user *optlen, unsigned len)
+{
+	struct socket_smack *ssp;
+	int slen;
+	int rc = 0;
+
+	ssp = sock->sk->sk_security;
+	slen = strlen(ssp->smk_out);
+
+	if (slen > len)
+		rc = -ERANGE;
+	else if (copy_to_user(optval, ssp->smk_out, slen) != 0)
+		rc = -EFAULT;
+
+	if (put_user(slen, optlen) != 0)
+		rc = -EFAULT;
+
+	return rc;
+}
+
+
+/**
+ * smack_socket_getpeersec_dgram - pull in packet label
+ * @sock: the socket
+ * @skb: packet data
+ * @secid: pointer to where to put the secid of the packet
+ *
+ * Sets the netlabel socket state on sk from parent
+ */
+static int smack_socket_getpeersec_dgram(struct socket *sock,
+					 struct sk_buff *skb, u32 *secid)
+
+{
+	struct netlbl_lsm_secattr secattr;
+	struct sock *sk;
+	char smack[SMK_LABELLEN];
+	u32 s;
+	int rc;
+
+	/*
+	 * Only works for families with packets.
+	 */
+	if (sock != NULL) {
+		sk = sock->sk;
+		if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
+			return 0;
+	}
+	/*
+	 * Translate what netlabel gave us.
+	 */
+	memset(smack, '\0', SMK_LABELLEN);
+	netlbl_secattr_init(&secattr);
+	rc = netlbl_skbuff_getattr(skb, &secattr);
+	if (rc == 0)
+		smack_from_secattr(&secattr, smack);
+	netlbl_secattr_destroy(&secattr);
+
+	/*
+	 * Give up if we couldn't get anything
+	 */
+	if (rc != 0)
+		return rc;
+
+	s = smack_to_secid(smack);
+	if (s == 0)
+		return -EINVAL;
+
+	*secid = s;
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
+				struct task_struct *context, key_perm_t perm)
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
+/*
+ * smack_secid_to_secctx - return the smack label for a secid
+ * @secid: incoming integer
+ * @secdata: destination
+ * @seclen: how long it is
+ *
+ * Exists for networking code.
+ */
+static int smack_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+{
+	char *sp = smack_from_secid(secid);
+
+	*secdata = sp;
+	*seclen = strlen(sp);
+	return 0;
+}
+
+/*
+ * smack_release_secctx - don't do anything.
+ * @key_ref: unused
+ * @context: unused
+ * @perm: unused
+ *
+ * Exists to make sure nothing gets done, and properly
+ */
+static void smack_release_secctx(char *secdata, u32 seclen)
+{
+}
+
+static struct security_operations smack_ops = {
+	.ptrace = 			smack_ptrace,
+	.capget = 			cap_capget,
+	.capset_check = 		cap_capset_check,
+	.capset_set = 			cap_capset_set,
+	.capable = 			cap_capable,
+	.syslog = 			smack_syslog,
+	.settime = 			cap_settime,
+	.vm_enough_memory = 		cap_vm_enough_memory,
+
+	.bprm_apply_creds = 		cap_bprm_apply_creds,
+	.bprm_set_security = 		cap_bprm_set_security,
+	.bprm_secureexec = 		cap_bprm_secureexec,
+
+	.sb_alloc_security = 		smack_sb_alloc_security,
+	.sb_free_security = 		smack_sb_free_security,
+	.sb_copy_data = 		smack_sb_copy_data,
+	.sb_kern_mount = 		smack_sb_kern_mount,
+	.sb_statfs = 			smack_sb_statfs,
+	.sb_mount = 			smack_sb_mount,
+	.sb_umount = 			smack_sb_umount,
+
+	.inode_alloc_security = 	smack_inode_alloc_security,
+	.inode_free_security = 		smack_inode_free_security,
+	.inode_init_security = 		smack_inode_init_security,
+	.inode_link = 			smack_inode_link,
+	.inode_unlink = 		smack_inode_unlink,
+	.inode_rmdir = 			smack_inode_rmdir,
+	.inode_rename = 		smack_inode_rename,
+	.inode_permission = 		smack_inode_permission,
+	.inode_setattr = 		smack_inode_setattr,
+	.inode_getattr = 		smack_inode_getattr,
+	.inode_setxattr = 		smack_inode_setxattr,
+	.inode_post_setxattr = 		smack_inode_post_setxattr,
+	.inode_getxattr = 		smack_inode_getxattr,
+	.inode_removexattr = 		smack_inode_removexattr,
+	.inode_getsecurity = 		smack_inode_getsecurity,
+	.inode_setsecurity = 		smack_inode_setsecurity,
+	.inode_listsecurity = 		smack_inode_listsecurity,
+
+	.file_permission = 		smack_file_permission,
+	.file_alloc_security = 		smack_file_alloc_security,
+	.file_free_security = 		smack_file_free_security,
+	.file_ioctl = 			smack_file_ioctl,
+	.file_lock = 			smack_file_lock,
+	.file_fcntl = 			smack_file_fcntl,
+	.file_set_fowner = 		smack_file_set_fowner,
+	.file_send_sigiotask = 		smack_file_send_sigiotask,
+	.file_receive = 		smack_file_receive,
+
+	.task_alloc_security = 		smack_task_alloc_security,
+	.task_free_security = 		smack_task_free_security,
+	.task_post_setuid =		cap_task_post_setuid,
+	.task_setpgid = 		smack_task_setpgid,
+	.task_getpgid = 		smack_task_getpgid,
+	.task_getsid = 			smack_task_getsid,
+	.task_getsecid = 		smack_task_getsecid,
+	.task_setnice = 		smack_task_setnice,
+	.task_setioprio = 		smack_task_setioprio,
+	.task_getioprio = 		smack_task_getioprio,
+	.task_setscheduler = 		smack_task_setscheduler,
+	.task_getscheduler = 		smack_task_getscheduler,
+	.task_movememory = 		smack_task_movememory,
+	.task_kill = 			smack_task_kill,
+	.task_wait = 			smack_task_wait,
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
+	.d_instantiate = 		smack_d_instantiate,
+
+	.getprocattr = 			smack_getprocattr,
+	.setprocattr = 			smack_setprocattr,
+
+	.unix_stream_connect = 		smack_unix_stream_connect,
+	.unix_may_send = 		smack_unix_may_send,
+
+	.socket_post_create = 		smack_socket_post_create,
+	.socket_sock_rcv_skb = 		smack_socket_sock_rcv_skb,
+	.socket_getpeersec_stream =	smack_socket_getpeersec_stream,
+	.socket_getpeersec_dgram =	smack_socket_getpeersec_dgram,
+	.sk_alloc_security = 		smack_sk_alloc_security,
+	.sk_free_security = 		smack_sk_free_security,
+	.sock_graft = 			smack_sock_graft,
+	.inet_conn_request = 		smack_inet_conn_request,
+ /* key management security hooks */
+#ifdef CONFIG_KEYS
+	.key_alloc = 			smack_key_alloc,
+	.key_free = 			smack_key_free,
+	.key_permission = 		smack_key_permission,
+#endif /* CONFIG_KEYS */
+	.secid_to_secctx = 		smack_secid_to_secctx,
+	.release_secctx = 		smack_release_secctx,
+};
+
+DEFINE_MUTEX(smack_list_lock);
+DEFINE_MUTEX(smack_known_lock);
+DEFINE_MUTEX(smack_cipso_lock);
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
+	 * Initialize locks
+	 */
+	spin_lock_init(&smack_known_unset.smk_cipsolock);
+	spin_lock_init(&smack_known_huh.smk_cipsolock);
+	spin_lock_init(&smack_known_hat.smk_cipsolock);
+	spin_lock_init(&smack_known_star.smk_cipsolock);
+	spin_lock_init(&smack_known_floor.smk_cipsolock);
+	spin_lock_init(&smack_known_invalid.smk_cipsolock);
+
+	mutex_init(&smack_known_lock);
+	mutex_init(&smack_list_lock);
+	mutex_init(&smack_cipso_lock);
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
diff -puN /dev/null security/smack/smackfs.c
--- /dev/null
+++ a/security/smack/smackfs.c
@@ -0,0 +1,975 @@
+/*
+ * Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *  	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation, version 2.
+ *
+ * Authors:
+ * 	Casey Schaufler <casey@schaufler-ca.com>
+ * 	Ahmed S. Darwish <darwish.07@gmail.com>
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
+#include <net/cipso_ipv4.h>
+#include <linux/seq_file.h>
+#include <linux/ctype.h>
+#include "smack.h"
+
+/*
+ * smackfs pseudo filesystem.
+ */
+
+enum smk_inos {
+	SMK_ROOT_INO	= 2,
+	SMK_LOAD	= 3,	/* load policy */
+	SMK_CIPSO	= 4,	/* load label -> CIPSO mapping */
+	SMK_DOI		= 5,	/* CIPSO DOI */
+	SMK_DIRECT	= 6,	/* CIPSO level indicating direct label */
+	SMK_AMBIENT	= 7,	/* internet ambient label */
+	SMK_NLTYPE	= 8,	/* label scheme to use by default */
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
+struct smk_list_entry *smack_list;
+
+#define	SEQ_READ_FINISHED	1
+
+/*
+ * Disable concurrent writing open() operations
+ */
+static struct semaphore smack_write_sem;
+
+/*
+ * Values for parsing cipso rules
+ * SMK_DIGITLEN: Length of a digit field in a rule.
+ * SMK_CIPSOMEN: Minimum possible cipso rule length.
+ */
+#define SMK_DIGITLEN 4
+#define SMK_CIPSOMIN (SMK_MAXLEN + 2 * SMK_DIGITLEN)
+
+/*
+ * Seq_file read operations for /smack/load
+ */
+
+static void *load_seq_start(struct seq_file *s, loff_t *pos)
+{
+	if (*pos == SEQ_READ_FINISHED)
+		return NULL;
+
+	return smack_list;
+}
+
+static void *load_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct smk_list_entry *skp = ((struct smk_list_entry *) v)->smk_next;
+
+	if (skp == NULL)
+		*pos = SEQ_READ_FINISHED;
+
+	return skp;
+}
+
+static int load_seq_show(struct seq_file *s, void *v)
+{
+	struct smk_list_entry *slp = (struct smk_list_entry *) v;
+	struct smack_rule *srp = &slp->smk_rule;
+
+	seq_printf(s, "%s %s", (char *)srp->smk_subject,
+		   (char *)srp->smk_object);
+
+	seq_putc(s, ' ');
+
+	if (srp->smk_access & MAY_READ)
+		seq_putc(s, 'r');
+	if (srp->smk_access & MAY_WRITE)
+		seq_putc(s, 'w');
+	if (srp->smk_access & MAY_EXEC)
+		seq_putc(s, 'x');
+	if (srp->smk_access & MAY_APPEND)
+		seq_putc(s, 'a');
+	if (srp->smk_access == 0)
+		seq_putc(s, '-');
+
+	seq_putc(s, '\n');
+
+	return 0;
+}
+
+static void load_seq_stop(struct seq_file *s, void *v)
+{
+	/* No-op */
+}
+
+static struct seq_operations load_seq_ops = {
+	.start = load_seq_start,
+	.next  = load_seq_next,
+	.show  = load_seq_show,
+	.stop  = load_seq_stop,
+};
+
+/**
+ * smk_open_load - open() for /smack/load
+ * @inode: inode structure representing file
+ * @file: "load" file pointer
+ *
+ * For reading, use load_seq_* seq_file reading operations.
+ */
+static int smk_open_load(struct inode *inode, struct file *file)
+{
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
+		return seq_open(file, &load_seq_ops);
+
+	if (down_interruptible(&smack_write_sem))
+		return -ERESTARTSYS;
+
+	return 0;
+}
+
+/**
+ * smk_release_load - release() for /smack/load
+ * @inode: inode structure representing file
+ * @file: "load" file pointer
+ *
+ * For a reading session, use the seq_file release
+ * implementation.
+ * Otherwise, we are at the end of a writing session so
+ * clean everything up.
+ */
+static int smk_release_load(struct inode *inode, struct file *file)
+{
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
+		return seq_release(inode, file);
+
+	up(&smack_write_sem);
+	return 0;
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
+	}
+
+	mutex_unlock(&smack_list_lock);
+
+	return;
+}
+
+/**
+ * smk_write_load - write() for /smack/load
+ * @filp: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start - must be 0
+ *
+ * Get one smack access rule from above.
+ * The format is exactly:
+ *     char subject[SMK_LABELLEN]
+ *     char object[SMK_LABELLEN]
+ *     char access[SMK_ACCESSKINDS]
+ *
+ *     Anything following is commentary and ignored.
+ *
+ * writes must be SMK_LABELLEN+SMK_LABELLEN+4 bytes.
+ */
+#define MINIMUM_LOAD (SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSKINDS)
+
+static ssize_t smk_write_load(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	struct smack_rule rule;
+	char *data;
+	int rc = -EINVAL;
+
+	/*
+	 * Must have privilege.
+	 * No partial writes.
+	 * Enough data must be present.
+	 */
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+	if (*ppos != 0)
+		return -EINVAL;
+	if (count < MINIMUM_LOAD)
+		return -EINVAL;
+
+	data = kzalloc(count, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, count) != 0) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	rule.smk_subject = smk_import(data, 0);
+	if (rule.smk_subject == NULL)
+		goto out;
+
+	rule.smk_object = smk_import(data + SMK_LABELLEN, 0);
+	if (rule.smk_object == NULL)
+		goto out;
+
+	rule.smk_access = 0;
+
+	switch (data[SMK_LABELLEN + SMK_LABELLEN]) {
+	case '-':
+		break;
+	case 'r':
+	case 'R':
+		rule.smk_access |= MAY_READ;
+		break;
+	default:
+		goto out;
+	}
+
+	switch (data[SMK_LABELLEN + SMK_LABELLEN + 1]) {
+	case '-':
+		break;
+	case 'w':
+	case 'W':
+		rule.smk_access |= MAY_WRITE;
+		break;
+	default:
+		goto out;
+	}
+
+	switch (data[SMK_LABELLEN + SMK_LABELLEN + 2]) {
+	case '-':
+		break;
+	case 'x':
+	case 'X':
+		rule.smk_access |= MAY_EXEC;
+		break;
+	default:
+		goto out;
+	}
+
+	switch (data[SMK_LABELLEN + SMK_LABELLEN + 3]) {
+	case '-':
+		break;
+	case 'a':
+	case 'A':
+		rule.smk_access |= MAY_READ;
+		break;
+	default:
+		goto out;
+	}
+
+	smk_set_access(&rule);
+	rc = count;
+
+out:
+	kfree(data);
+	return rc;
+}
+
+static const struct file_operations smk_load_ops = {
+	.open           = smk_open_load,
+	.read		= seq_read,
+	.llseek         = seq_lseek,
+	.write		= smk_write_load,
+	.release        = smk_release_load,
+};
+
+/**
+ * smk_cipso_doi - initialize the CIPSO domain
+ */
+void smk_cipso_doi(void)
+{
+	int rc;
+	struct cipso_v4_doi *doip;
+	struct netlbl_audit audit_info;
+
+	rc = netlbl_cfg_map_del(NULL, &audit_info);
+	if (rc != 0)
+		printk(KERN_WARNING "%s:%d remove rc = %d\n",
+		       __func__, __LINE__, rc);
+
+	doip = kmalloc(sizeof(struct cipso_v4_doi), GFP_KERNEL);
+	if (doip == NULL)
+		panic("smack:  Failed to initialize cipso DOI.\n");
+	doip->map.std = NULL;
+	doip->doi = smk_cipso_doi_value;
+	doip->type = CIPSO_V4_MAP_PASS;
+	doip->tags[0] = CIPSO_V4_TAG_RBITMAP;
+	for (rc = 1; rc < CIPSO_V4_TAG_MAXCNT; rc++)
+		doip->tags[rc] = CIPSO_V4_TAG_INVALID;
+
+	rc = netlbl_cfg_cipsov4_add_map(doip, NULL, &audit_info);
+	if (rc != 0)
+		printk(KERN_WARNING "%s:%d add rc = %d\n",
+		       __func__, __LINE__, rc);
+}
+
+/*
+ * Seq_file read operations for /smack/cipso
+ */
+
+static void *cipso_seq_start(struct seq_file *s, loff_t *pos)
+{
+	if (*pos == SEQ_READ_FINISHED)
+		return NULL;
+
+	return smack_known;
+}
+
+static void *cipso_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct smack_known *skp = ((struct smack_known *) v)->smk_next;
+
+	/*
+	 * Omit labels with no associated cipso value
+	 */
+	while (skp != NULL && !skp->smk_cipso)
+		skp = skp->smk_next;
+
+	if (skp == NULL)
+		*pos = SEQ_READ_FINISHED;
+
+	return skp;
+}
+
+/*
+ * Print cipso labels in format:
+ * label level[/cat[,cat]]
+ */
+static int cipso_seq_show(struct seq_file *s, void *v)
+{
+	struct smack_known *skp = (struct smack_known *) v;
+	struct smack_cipso *scp = skp->smk_cipso;
+	char *cbp;
+	char sep = '/';
+	int cat = 1;
+	int i;
+	unsigned char m;
+
+	if (scp == NULL)
+		return 0;
+
+	seq_printf(s, "%s %3d", (char *)&skp->smk_known, scp->smk_level);
+
+	cbp = scp->smk_catset;
+	for (i = 0; i < SMK_LABELLEN; i++)
+		for (m = 0x80; m != 0; m >>= 1) {
+			if (m & cbp[i]) {
+				seq_printf(s, "%c%d", sep, cat);
+				sep = ',';
+			}
+			cat++;
+		}
+
+	seq_putc(s, '\n');
+
+	return 0;
+}
+
+static void cipso_seq_stop(struct seq_file *s, void *v)
+{
+	/* No-op */
+}
+
+static struct seq_operations cipso_seq_ops = {
+	.start = cipso_seq_start,
+	.stop  = cipso_seq_stop,
+	.next  = cipso_seq_next,
+	.show  = cipso_seq_show,
+};
+
+/**
+ * smk_open_cipso - open() for /smack/cipso
+ * @inode: inode structure representing file
+ * @file: "cipso" file pointer
+ *
+ * Connect our cipso_seq_* operations with /smack/cipso
+ * file_operations
+ */
+static int smk_open_cipso(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &cipso_seq_ops);
+}
+
+/**
+ * smk_write_cipso - write() for /smack/cipso
+ * @filp: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Accepts only one cipso rule per write call.
+ * Returns number of bytes written or error code, as appropriate
+ */
+static ssize_t smk_write_cipso(struct file *file, const char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	struct smack_known *skp;
+	struct smack_cipso *scp = NULL;
+	char mapcatset[SMK_LABELLEN];
+	int maplevel;
+	int cat;
+	int catlen;
+	ssize_t rc = -EINVAL;
+	char *data = NULL;
+	char *rule;
+	int ret;
+	int i;
+
+	/*
+	 * Must have privilege.
+	 * No partial writes.
+	 * Enough data must be present.
+	 */
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+	if (*ppos != 0)
+		return -EINVAL;
+	if (count <= SMK_CIPSOMIN)
+		return -EINVAL;
+
+	data = kzalloc(count + 1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, count) != 0) {
+		rc = -EFAULT;
+		goto unlockedout;
+	}
+
+	data[count] = '\0';
+	rule = data;
+	/*
+	 * Only allow one writer at a time. Writes should be
+	 * quite rare and small in any case.
+	 */
+	mutex_lock(&smack_cipso_lock);
+
+	skp = smk_import_entry(rule, 0);
+	if (skp == NULL)
+		goto out;
+
+	rule += SMK_LABELLEN;;
+	ret = sscanf(rule, "%d", &maplevel);
+	if (ret != 1 || maplevel > SMACK_CIPSO_MAXLEVEL)
+		goto out;
+
+	rule += SMK_DIGITLEN;
+	ret = sscanf(rule, "%d", &catlen);
+	if (ret != 1 || catlen > SMACK_CIPSO_MAXCATNUM)
+		goto out;
+
+	if (count <= (SMK_CIPSOMIN + catlen * SMK_DIGITLEN))
+		goto out;
+
+	memset(mapcatset, 0, sizeof(mapcatset));
+
+	for (i = 0; i < catlen; i++) {
+		rule += SMK_DIGITLEN;
+		ret = sscanf(rule, "%d", &cat);
+		if (ret != 1 || cat > SMACK_CIPSO_MAXCATVAL)
+			goto out;
+
+		smack_catset_bit(cat, mapcatset);
+	}
+
+	if (skp->smk_cipso == NULL) {
+		scp = kzalloc(sizeof(struct smack_cipso), GFP_KERNEL);
+		if (scp == NULL) {
+			rc = -ENOMEM;
+			goto out;
+		}
+	}
+
+	spin_lock_bh(&skp->smk_cipsolock);
+
+	if (scp == NULL)
+		scp = skp->smk_cipso;
+	else
+		skp->smk_cipso = scp;
+
+	scp->smk_level = maplevel;
+	memcpy(scp->smk_catset, mapcatset, sizeof(mapcatset));
+
+	spin_unlock_bh(&skp->smk_cipsolock);
+
+	rc = count;
+out:
+	mutex_unlock(&smack_cipso_lock);
+unlockedout:
+	kfree(data);
+	return rc;
+}
+
+static const struct file_operations smk_cipso_ops = {
+	.open           = smk_open_cipso,
+	.read		= seq_read,
+	.llseek         = seq_lseek,
+	.write		= smk_write_cipso,
+	.release        = seq_release,
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
+			    size_t count, loff_t *ppos)
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
+			     size_t count, loff_t *ppos)
+{
+	char temp[80];
+	int i;
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	if (count >= sizeof(temp) || count == 0)
+		return -EINVAL;
+
+	if (copy_from_user(temp, buf, count) != 0)
+		return -EFAULT;
+
+	temp[count] = '\0';
+
+	if (sscanf(temp, "%d", &i) != 1)
+		return -EINVAL;
+
+	smk_cipso_doi_value = i;
+
+	smk_cipso_doi();
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
+			       size_t count, loff_t *ppos)
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
+				size_t count, loff_t *ppos)
+{
+	char temp[80];
+	int i;
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	if (count >= sizeof(temp) || count == 0)
+		return -EINVAL;
+
+	if (copy_from_user(temp, buf, count) != 0)
+		return -EFAULT;
+
+	temp[count] = '\0';
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
+ * @cn: maximum to send along
+ * @ppos: where to start
+ *
+ * Returns number of bytes read or error code, as appropriate
+ */
+static ssize_t smk_read_ambient(struct file *filp, char __user *buf,
+				size_t cn, loff_t *ppos)
+{
+	ssize_t rc;
+	char out[SMK_LABELLEN];
+	int asize;
+
+	if (*ppos != 0)
+		return 0;
+	/*
+	 * Being careful to avoid a problem in the case where
+	 * smack_net_ambient gets changed in midstream.
+	 * Since smack_net_ambient is always set with a value
+	 * from the label list, including initially, and those
+	 * never get freed, the worst case is that the pointer
+	 * gets changed just after this strncpy, in which case
+	 * the value passed up is incorrect. Locking around
+	 * smack_net_ambient wouldn't be any better than this
+	 * copy scheme as by the time the caller got to look
+	 * at the ambient value it would have cleared the lock
+	 * and been changed.
+	 */
+	strncpy(out, smack_net_ambient, SMK_LABELLEN);
+	asize = strlen(out) + 1;
+
+	if (cn < asize)
+		return -EINVAL;
+
+	rc = simple_read_from_buffer(buf, cn, ppos, out, asize);
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
+				 size_t count, loff_t *ppos)
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
+
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
+				size_t count, loff_t *ppos)
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
+/**
+ * smk_fill_super - fill the /smackfs superblock
+ * @sb: the empty superblock
+ * @data: unused
+ * @silent: unused
+ *
+ * Fill in the well known entries for /smack
+ *
+ * Returns 0 on success, an error code on failure
+ */
+static int smk_fill_super(struct super_block *sb, void *data, int silent)
+{
+	int rc;
+	struct inode *root_inode;
+
+	static struct tree_descr smack_files[] = {
+		[SMK_LOAD]	=
+			{"load", &smk_load_ops, S_IRUGO|S_IWUSR},
+		[SMK_CIPSO]	=
+			{"cipso", &smk_cipso_ops, S_IRUGO|S_IWUSR},
+		[SMK_DOI]	=
+			{"doi", &smk_doi_ops, S_IRUGO|S_IWUSR},
+		[SMK_DIRECT]	=
+			{"direct", &smk_direct_ops, S_IRUGO|S_IWUSR},
+		[SMK_AMBIENT]	=
+			{"ambient", &smk_ambient_ops, S_IRUGO|S_IWUSR},
+		[SMK_NLTYPE]	=
+			{"nltype", &smk_nltype_ops, S_IRUGO|S_IWUSR},
+		/* last one */ {""}
+	};
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
+	sema_init(&smack_write_sem, 1);
+	smk_cipso_doi();
+
+	return err;
+}
+
+__initcall(init_smk_fs);
_

Patches currently in -mm which might be from casey@schaufler-ca.com are

vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-fix.patch
netlabel-introduce-a-new-kernel-configuration-api-for-netlabel.patch
smack-simplified-mandatory-access-control-kernel.patch
