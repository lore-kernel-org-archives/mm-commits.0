From: akpm@linux-foundation.org
Subject: [merged]
 kexec-make-kexec_segment-user-buffer-pointer-a-union.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:53 -0700
Message-ID: <53ea6e79.iOzTFz9e7yh+UfzY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:49145 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbaHLTny (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:54 -0400
Received: by mail-qg0-f74.google.com with SMTP id z60so1312727qgd.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: make kexec_segment user buffer pointer a union
has been removed from the -mm tree.  Its filename was
     kexec-make-kexec_segment-user-buffer-pointer-a-union.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec: make kexec_segment user buffer pointer a union

So far kexec_segment->buf was always a user space pointer as user space
passed the array of kexec_segment structures and kernel copied it.

But with new system call, list of kexec segments will be prepared by
kernel and kexec_segment->buf will point to a kernel memory.

So while I was adding code where I made assumption that ->buf is pointing
to kernel memory, sparse started giving warning.

Make ->buf a union.  And where a user space pointer is expected, access it
using ->buf and where a kernel space pointer is expected, access it using
->kbuf.  That takes care of sparse warnings.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN include/linux/kexec.h~kexec-make-kexec_segment-user-buffer-pointer-a-union include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-make-kexec_segment-user-buffer-pointer-a-union
+++ a/include/linux/kexec.h
@@ -69,7 +69,18 @@ typedef unsigned long kimage_entry_t;
 #define IND_SOURCE       0x8
 
 struct kexec_segment {
-	void __user *buf;
+	/*
+	 * This pointer can point to user memory if kexec_load() system
+	 * call is used or will point to kernel memory if
+	 * kexec_file_load() system call is used.
+	 *
+	 * Use ->buf when expecting to deal with user memory and use ->kbuf
+	 * when expecting to deal with kernel memory.
+	 */
+	union {
+		void __user *buf;
+		void *kbuf;
+	};
 	size_t bufsz;
 	unsigned long mem;
 	size_t memsz;
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch

