From: akpm@linux-foundation.org
Subject: + ia64-reuse-append_elf_note-and-final_note-functions.patch added to -mm tree
Date: Tue, 28 Mar 2017 16:21:26 -0700
Message-ID: <58daeff6.LTWLSQYAwuOZFHIb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51664 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753312AbdC1XVa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 19:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hbathini@linux.vnet.ibm.com, dyoung@redhat.com, ebiederm@xmission.com, fenghua.yu@intel.com, mahesh@linux.vnet.ibm.com, mpe@ellerman.id.au, tony.luck@intel.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: reuse append_elf_note() and final_note() functions
has been added to the -mm tree.  Its filename is
     ia64-reuse-append_elf_note-and-final_note-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ia64-reuse-append_elf_note-and-final_note-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ia64-reuse-append_elf_note-and-final_note-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hari Bathini <hbathini@linux.vnet.ibm.com>
Subject: ia64: reuse append_elf_note() and final_note() functions

Get rid of multiple definitions of append_elf_note() & final_note()
functions.  Reuse these functions compiled under CONFIG_CRASH_CORE Also,
define Elf_Word and use it instead of generic u32 or the more specific
Elf64_Word.

Link: http://lkml.kernel.org/r/149035342324.6881.11667840929850361402.stgit@hbathini.in.ibm.com
Signed-off-by: Hari Bathini <hbathini@linux.vnet.ibm.com>
Acked-by: Dave Young <dyoung@redhat.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/crash.c   |   22 ----------------------
 include/linux/crash_core.h |    4 ++++
 include/linux/elf.h        |    2 ++
 kernel/crash_core.c        |   32 +++++++++++++-------------------
 kernel/kexec_core.c        |   28 ----------------------------
 5 files changed, 19 insertions(+), 69 deletions(-)

diff -puN arch/ia64/kernel/crash.c~ia64-reuse-append_elf_note-and-final_note-functions arch/ia64/kernel/crash.c
--- a/arch/ia64/kernel/crash.c~ia64-reuse-append_elf_note-and-final_note-functions
+++ a/arch/ia64/kernel/crash.c
@@ -27,28 +27,6 @@ static int kdump_freeze_monarch;
 static int kdump_on_init = 1;
 static int kdump_on_fatal_mca = 1;
 
-static inline Elf64_Word
-*append_elf_note(Elf64_Word *buf, char *name, unsigned type, void *data,
-		size_t data_len)
-{
-	struct elf_note *note = (struct elf_note *)buf;
-	note->n_namesz = strlen(name) + 1;
-	note->n_descsz = data_len;
-	note->n_type   = type;
-	buf += (sizeof(*note) + 3)/4;
-	memcpy(buf, name, note->n_namesz);
-	buf += (note->n_namesz + 3)/4;
-	memcpy(buf, data, data_len);
-	buf += (data_len + 3)/4;
-	return buf;
-}
-
-static void
-final_note(void *buf)
-{
-	memset(buf, 0, sizeof(struct elf_note));
-}
-
 extern void ia64_dump_cpu_regs(void *);
 
 static DEFINE_PER_CPU(struct elf_prstatus, elf_prstatus);
diff -puN include/linux/crash_core.h~ia64-reuse-append_elf_note-and-final_note-functions include/linux/crash_core.h
--- a/include/linux/crash_core.h~ia64-reuse-append_elf_note-and-final_note-functions
+++ a/include/linux/crash_core.h
@@ -55,6 +55,10 @@ extern u32 vmcoreinfo_note[VMCOREINFO_NO
 extern size_t vmcoreinfo_size;
 extern size_t vmcoreinfo_max_size;
 
+Elf_Word *append_elf_note(Elf_Word *buf, char *name, unsigned int type,
+			  void *data, size_t data_len);
+void final_note(Elf_Word *buf);
+
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
 int parse_crashkernel_high(char *cmdline, unsigned long long system_ram,
diff -puN include/linux/elf.h~ia64-reuse-append_elf_note-and-final_note-functions include/linux/elf.h
--- a/include/linux/elf.h~ia64-reuse-append_elf_note-and-final_note-functions
+++ a/include/linux/elf.h
@@ -29,6 +29,7 @@ extern Elf32_Dyn _DYNAMIC [];
 #define elf_note	elf32_note
 #define elf_addr_t	Elf32_Off
 #define Elf_Half	Elf32_Half
+#define Elf_Word	Elf32_Word
 
 #else
 
@@ -39,6 +40,7 @@ extern Elf64_Dyn _DYNAMIC [];
 #define elf_note	elf64_note
 #define elf_addr_t	Elf64_Off
 #define Elf_Half	Elf64_Half
+#define Elf_Word	Elf64_Word
 
 #endif
 
diff -puN kernel/crash_core.c~ia64-reuse-append_elf_note-and-final_note-functions kernel/crash_core.c
--- a/kernel/crash_core.c~ia64-reuse-append_elf_note-and-final_note-functions
+++ a/kernel/crash_core.c
@@ -291,32 +291,26 @@ int __init parse_crashkernel_low(char *c
 				"crashkernel=", suffix_tbl[SUFFIX_LOW]);
 }
 
-static u32 *append_elf_note(u32 *buf, char *name, unsigned int type,
-			    void *data, size_t data_len)
+Elf_Word *append_elf_note(Elf_Word *buf, char *name, unsigned int type,
+			  void *data, size_t data_len)
 {
-	struct elf_note note;
+	struct elf_note *note = (struct elf_note *)buf;
 
-	note.n_namesz = strlen(name) + 1;
-	note.n_descsz = data_len;
-	note.n_type   = type;
-	memcpy(buf, &note, sizeof(note));
-	buf += (sizeof(note) + 3)/4;
-	memcpy(buf, name, note.n_namesz);
-	buf += (note.n_namesz + 3)/4;
-	memcpy(buf, data, note.n_descsz);
-	buf += (note.n_descsz + 3)/4;
+	note->n_namesz = strlen(name) + 1;
+	note->n_descsz = data_len;
+	note->n_type   = type;
+	buf += DIV_ROUND_UP(sizeof(*note), sizeof(Elf_Word));
+	memcpy(buf, name, note->n_namesz);
+	buf += DIV_ROUND_UP(note->n_namesz, sizeof(Elf_Word));
+	memcpy(buf, data, data_len);
+	buf += DIV_ROUND_UP(data_len, sizeof(Elf_Word));
 
 	return buf;
 }
 
-static void final_note(u32 *buf)
+void final_note(Elf_Word *buf)
 {
-	struct elf_note note;
-
-	note.n_namesz = 0;
-	note.n_descsz = 0;
-	note.n_type   = 0;
-	memcpy(buf, &note, sizeof(note));
+	memset(buf, 0, sizeof(struct elf_note));
 }
 
 static void update_vmcoreinfo_note(void)
diff -puN kernel/kexec_core.c~ia64-reuse-append_elf_note-and-final_note-functions kernel/kexec_core.c
--- a/kernel/kexec_core.c~ia64-reuse-append_elf_note-and-final_note-functions
+++ a/kernel/kexec_core.c
@@ -990,34 +990,6 @@ unlock:
 	return ret;
 }
 
-static u32 *append_elf_note(u32 *buf, char *name, unsigned type, void *data,
-			    size_t data_len)
-{
-	struct elf_note note;
-
-	note.n_namesz = strlen(name) + 1;
-	note.n_descsz = data_len;
-	note.n_type   = type;
-	memcpy(buf, &note, sizeof(note));
-	buf += (sizeof(note) + 3)/4;
-	memcpy(buf, name, note.n_namesz);
-	buf += (note.n_namesz + 3)/4;
-	memcpy(buf, data, note.n_descsz);
-	buf += (note.n_descsz + 3)/4;
-
-	return buf;
-}
-
-static void final_note(u32 *buf)
-{
-	struct elf_note note;
-
-	note.n_namesz = 0;
-	note.n_descsz = 0;
-	note.n_type   = 0;
-	memcpy(buf, &note, sizeof(note));
-}
