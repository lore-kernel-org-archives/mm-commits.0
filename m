From: akpm@linux-foundation.org
Subject: + scripts-namespacepl-add-source-file-location-exceptions.patch added to -mm tree
Date: Thu, 14 Oct 2010 15:56:39 -0700
Message-ID: <201010142256.o9EMud4Z024309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563Ab0JNW5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Oct 2010 18:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, amwang@redhat.com, mmarek@suse.cz


The patch titled
     scripts/namespace.pl: add source file location exceptions
has been added to the -mm tree.  Its filename is
     scripts-namespacepl-add-source-file-location-exceptions.patch

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
Subject: scripts/namespace.pl: add source file location exceptions
From: Stephen Hemminger <shemminger@vyatta.com>

Teach namespace checker about some special case files where the source is
in unusual location.  This fixes many of the source file not found errors
(more can be added), and also prevents false positives for functions not
being used.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/namespace.pl |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN scripts/namespace.pl~scripts-namespacepl-add-source-file-location-exceptions scripts/namespace.pl
--- a/scripts/namespace.pl~scripts-namespacepl-add-source-file-location-exceptions
+++ a/scripts/namespace.pl
@@ -141,6 +141,26 @@ my %nameexception = (
     'VDSO32_sigreturn'	=> 1,
 );
 
+# Files with exceptions to source file location
+my %sourceloc = (
+    'net/dccp/dccp_probe.o'	=> 'probe',
+    'net/dccp/dccp_ipv4.o'	=> 'ipv4',
+    'net/dccp/dccp_ipv6.o'	=> 'ipv6',
+    'net/dccp/dccp_diag.o'	=> 'diag',
+    'drivers/char/hw_random/rng-core.o'	=> 'core',
+    'fs/fat/msdos.o'		=> 'namei_msdos',
+    'fs/fat/vfat.o'		=> 'namei_vfat',
+    'fs/nfs_common/nfs_acl.o'	=> 'nfsacl',
+    'sound/soundcore.o'		=> 'sound_core',
+    'drivers/md/dm-mirror.o'	=> 'dm-raid1',
+    'drivers/message/i2o/i2o_bus.o' => 'bus-osm',
+    'arch/x86/kvm/kvm-amd.o'	=> 'svm',
+    'arch/x86/kvm/kvm-intel.o'	=> 'vmx',
+    'arch/x86/crypto/twofish-x86_64.o' => 'twofish-x86_64-asm_64',
+    'arch/x86/crypto/aes-x86_64.o' => 'aes-x86_64-asm_64',
+    'arch/x86/crypto/aesni-intel.o' => 'aesni-intel_asm',
+    'arch/x86/crypto/salsa20-x86_64.o' => 'salsa20-x86_64-asm_64',
+);
 
 &find(\&linux_objects, '.');	# find the objects and do_nm on them
 &list_multiply_defined();
@@ -228,11 +248,15 @@ sub do_nm
 		return;
 	}
 	($source = $basename) =~ s/\.o$//;
+
+	$source = $sourceloc{$fullname} if ($sourceloc{$fullname});
+
 	if (-e "$source.c" || -e "$source.S") {
 		$source = "$objtree$File::Find::dir/$source";
 	} else {
 		$source = "$srctree$File::Find::dir/$source";
 	}
+
 	if (! -e "$source.c" && ! -e "$source.S") {
 		# No obvious source, exclude the object if it is conglomerate
 	        open(my $objdumpdata, "$objdump $basename|")
_

Patches currently in -mm which might be from shemminger@vyatta.com are

linux-next.patch
scripts-namespacepl-fix-wrong-source-path.patch
scripts-namespacepl-update-file-exclusion-list.patch
scripts-namespacepl-some-bug-fixes.patch
scripts-namespacepl-improve-to-get-more-correct-results.patch
scripts-namespacepl-add-source-file-location-exceptions.patch

