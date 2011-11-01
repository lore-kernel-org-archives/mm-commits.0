From: akpm@linux-foundation.org
Subject: [merged] kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:16:31 -0700
Message-ID: <201111012116.pA1LGVYW020915@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16815 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1KAVQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:16:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, dhowells@redhat.com, jason.wessel@windriver.com, jesper.nilsson@axis.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kgdb: follow rename pack_hex_byte() to hex_byte_pack()
has been removed from the -mm tree.  Its filename was
     kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kgdb: follow rename pack_hex_byte() to hex_byte_pack()

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/kgdb.c |    6 +--
 arch/cris/arch-v32/kernel/kgdb.c |   14 +++----
 arch/frv/kernel/gdb-stub.c       |   44 ++++++++++++------------
 arch/mn10300/kernel/gdb-stub.c   |   52 ++++++++++++++---------------
 kernel/debug/gdbstub.c           |   12 +++---
 5 files changed, 64 insertions(+), 64 deletions(-)

diff -puN arch/cris/arch-v10/kernel/kgdb.c~kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack arch/cris/arch-v10/kernel/kgdb.c
--- a/arch/cris/arch-v10/kernel/kgdb.c~kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack
+++ a/arch/cris/arch-v10/kernel/kgdb.c
@@ -694,7 +694,7 @@ mem2hex(char *buf, unsigned char *mem, i
                 /* Valid mem address. */
                 for (i = 0; i < count; i++) {
                         ch = *mem++;
-			buf = pack_hex_byte(buf, ch);
+			buf = hex_byte_pack(buf, ch);
                 }
         }
         
@@ -868,7 +868,7 @@ stub_is_stopped(int sigval)
 	/* Send trap type (converted to signal) */
 
 	*ptr++ = 'T';
-	ptr = pack_hex_byte(ptr, sigval);
+	ptr = hex_byte_pack(ptr, sigval);
 
 	/* Send register contents. We probably only need to send the
 	 * PC, frame pointer and stack pointer here. Other registers will be
@@ -881,7 +881,7 @@ stub_is_stopped(int sigval)
                 status = read_register (regno, &reg_cont);
                 
 		if (status == SUCCESS) {
-			ptr = pack_hex_byte(ptr, regno);
+			ptr = hex_byte_pack(ptr, regno);
                         *ptr++ = ':';
 
                         ptr = mem2hex(ptr, (unsigned char *)&reg_cont,
diff -puN arch/cris/arch-v32/kernel/kgdb.c~kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack arch/cris/arch-v32/kernel/kgdb.c
--- a/arch/cris/arch-v32/kernel/kgdb.c~kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack
+++ a/arch/cris/arch-v32/kernel/kgdb.c
@@ -677,7 +677,7 @@ mem2hex(char *buf, unsigned char *mem, i
                 /* Valid mem address. */
 		for (i = 0; i < count; i++) {
 			ch = *mem++;
-			buf = pack_hex_byte(buf, ch);
+			buf = hex_byte_pack(buf, ch);
 		}
         }
         /* Terminate properly. */
@@ -695,7 +695,7 @@ mem2hex_nbo(char *buf, unsigned char *me
 	mem += count - 1;
 	for (i = 0; i < count; i++) {
 		ch = *mem--;
-		buf = pack_hex_byte(buf, ch);
+		buf = hex_byte_pack(buf, ch);
         }
 
         /* Terminate properly. */
@@ -880,7 +880,7 @@ stub_is_stopped(int sigval)
 	/* Send trap type (converted to signal) */
 
 	*ptr++ = 'T';
-	ptr = pack_hex_byte(ptr, sigval);
+	ptr = hex_byte_pack(ptr, sigval);
 
 	if (((reg.exs & 0xff00) >> 8) == 0xc) {
 
@@ -988,26 +988,26 @@ stub_is_stopped(int sigval)
 	}
 	/* Only send PC, frame and stack pointer. */
 	read_register(PC, &reg_cont);
-	ptr = pack_hex_byte(ptr, PC);
+	ptr = hex_byte_pack(ptr, PC);
 	*ptr++ = ':';
 	ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[PC]);
 	*ptr++ = ';';
 
 	read_register(R8, &reg_cont);
-	ptr = pack_hex_byte(ptr, R8);
+	ptr = hex_byte_pack(ptr, R8);
 	*ptr++ = ':';
 	ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[R8]);
 	*ptr++ = ';';
 
 	read_register(SP, &reg_cont);
-	ptr = pack_hex_byte(ptr, SP);
+	ptr = hex_byte_pack(ptr, SP);
 	*ptr++ = ':';
 	ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[SP]);
 	*ptr++ = ';';
 
 	/* Send ERP as well; this will save us an entire register fetch in some cases. */
         read_register(ERP, &reg_cont);
-	ptr = pack_hex_byte(ptr, ERP);
+	ptr = hex_byte_pack(ptr, ERP);
         *ptr++ = ':';
         ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[ERP]);
         *ptr++ = ';';
diff -puN arch/frv/kernel/gdb-stub.c~kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack arch/frv/kernel/gdb-stub.c
--- a/arch/frv/kernel/gdb-stub.c~kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack
+++ a/arch/frv/kernel/gdb-stub.c
@@ -672,7 +672,7 @@ static unsigned char *mem2hex(const void
 	if ((uint32_t)mem&1 && count>=1) {
 		if (!gdbstub_read_byte(mem,ch))
 			return NULL;
-		buf = pack_hex_byte(buf, ch[0]);
+		buf = hex_byte_pack(buf, ch[0]);
 		mem++;
 		count--;
 	}
@@ -680,8 +680,8 @@ static unsigned char *mem2hex(const void
 	if ((uint32_t)mem&3 && count>=2) {
 		if (!gdbstub_read_word(mem,(uint16_t *)ch))
 			return NULL;
-		buf = pack_hex_byte(buf, ch[0]);
-		buf = pack_hex_byte(buf, ch[1]);
+		buf = hex_byte_pack(buf, ch[0]);
+		buf = hex_byte_pack(buf, ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -689,10 +689,10 @@ static unsigned char *mem2hex(const void
 	while (count>=4) {
 		if (!gdbstub_read_dword(mem,(uint32_t *)ch))
 			return NULL;
-		buf = pack_hex_byte(buf, ch[0]);
-		buf = pack_hex_byte(buf, ch[1]);
-		buf = pack_hex_byte(buf, ch[2]);
-		buf = pack_hex_byte(buf, ch[3]);
+		buf = hex_byte_pack(buf, ch[0]);
+		buf = hex_byte_pack(buf, ch[1]);
+		buf = hex_byte_pack(buf, ch[2]);
+		buf = hex_byte_pack(buf, ch[3]);
 		mem += 4;
 		count -= 4;
 	}
@@ -700,8 +700,8 @@ static unsigned char *mem2hex(const void
 	if (count>=2) {
 		if (!gdbstub_read_word(mem,(uint16_t *)ch))
 			return NULL;
-		buf = pack_hex_byte(buf, ch[0]);
-		buf = pack_hex_byte(buf, ch[1]);
+		buf = hex_byte_pack(buf, ch[0]);
+		buf = hex_byte_pack(buf, ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -709,7 +709,7 @@ static unsigned char *mem2hex(const void
 	if (count>=1) {
 		if (!gdbstub_read_byte(mem,ch))
 			return NULL;
-		buf = pack_hex_byte(buf, ch[0]);
+		buf = hex_byte_pack(buf, ch[0]);
 	}
 
 	*buf = 0;
@@ -1498,21 +1498,21 @@ void gdbstub(int sigval)
 		ptr = mem2hex(title, ptr, sizeof(title) - 1,0);
 
 		hx = hex_asc_hi(brr >> 24);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_lo(brr >> 24);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_hi(brr >> 16);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_lo(brr >> 16);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_hi(brr >> 8);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_lo(brr >> 8);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_hi(brr);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_lo(brr);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1526,10 +1526,10 @@ void gdbstub(int sigval)
 
 	/* Send trap type (converted to signal) */
 	*ptr++ = 'T';
-	ptr = pack_hex_byte(ptr, sigval);
+	ptr = hex_byte_pack(ptr, sigval);
 
 	/* Send Error PC */
-	ptr = pack_hex_byte(ptr, GDB_REG_PC);
+	ptr = hex_byte_pack(ptr, GDB_REG_PC);
 	*ptr++ = ':';
 	ptr = mem2hex(&__debug_frame->pc, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1537,7 +1537,7 @@ void gdbstub(int sigval)
 	/*
 	 * Send frame pointer
 	 */
-	ptr = pack_hex_byte(ptr, GDB_REG_FP);
+	ptr = hex_byte_pack(ptr, GDB_REG_FP);
 	*ptr++ = ':';
 	ptr = mem2hex(&__debug_frame->fp, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1545,7 +1545,7 @@ void gdbstub(int sigval)
 	/*
 	 * Send stack pointer
 	 */
-	ptr = pack_hex_byte(ptr, GDB_REG_SP);
+	ptr = hex_byte_pack(ptr, GDB_REG_SP);
 	*ptr++ = ':';
 	ptr = mem2hex(&__debug_frame->sp, ptr, 4, 0);
 	*ptr++ = ';';
diff -puN arch/mn10300/kernel/gdb-stub.c~kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack arch/mn10300/kernel/gdb-stub.c
--- a/arch/mn10300/kernel/gdb-stub.c~kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack
+++ a/arch/mn10300/kernel/gdb-stub.c
@@ -798,7 +798,7 @@ unsigned char *mem2hex(const void *_mem,
 	if ((u32) mem & 1 && count >= 1) {
 		if (gdbstub_read_byte(mem, ch) != 0)
 			return 0;
-		buf = pack_hex_byte(buf, ch[0]);
+		buf = hex_byte_pack(buf, ch[0]);
 		mem++;
 		count--;
 	}
@@ -806,8 +806,8 @@ unsigned char *mem2hex(const void *_mem,
 	if ((u32) mem & 3 && count >= 2) {
 		if (gdbstub_read_word(mem, ch) != 0)
 			return 0;
-		buf = pack_hex_byte(buf, ch[0]);
-		buf = pack_hex_byte(buf, ch[1]);
+		buf = hex_byte_pack(buf, ch[0]);
+		buf = hex_byte_pack(buf, ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -815,10 +815,10 @@ unsigned char *mem2hex(const void *_mem,
 	while (count >= 4) {
 		if (gdbstub_read_dword(mem, ch) != 0)
 			return 0;
-		buf = pack_hex_byte(buf, ch[0]);
-		buf = pack_hex_byte(buf, ch[1]);
-		buf = pack_hex_byte(buf, ch[2]);
-		buf = pack_hex_byte(buf, ch[3]);
+		buf = hex_byte_pack(buf, ch[0]);
+		buf = hex_byte_pack(buf, ch[1]);
+		buf = hex_byte_pack(buf, ch[2]);
+		buf = hex_byte_pack(buf, ch[3]);
 		mem += 4;
 		count -= 4;
 	}
@@ -826,8 +826,8 @@ unsigned char *mem2hex(const void *_mem,
 	if (count >= 2) {
 		if (gdbstub_read_word(mem, ch) != 0)
 			return 0;
-		buf = pack_hex_byte(buf, ch[0]);
-		buf = pack_hex_byte(buf, ch[1]);
+		buf = hex_byte_pack(buf, ch[0]);
+		buf = hex_byte_pack(buf, ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -835,7 +835,7 @@ unsigned char *mem2hex(const void *_mem,
 	if (count >= 1) {
 		if (gdbstub_read_byte(mem, ch) != 0)
 			return 0;
-		buf = pack_hex_byte(buf, ch[0]);
+		buf = hex_byte_pack(buf, ch[0]);
 	}
 
 	*buf = 0;
@@ -1273,13 +1273,13 @@ static int gdbstub(struct pt_regs *regs,
 		ptr = mem2hex(title, ptr, sizeof(title) - 1, 0);
 
 		hx = hex_asc_hi(excep >> 8);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_lo(excep >> 8);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_hi(excep);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_lo(excep);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1291,21 +1291,21 @@ static int gdbstub(struct pt_regs *regs,
 		ptr = mem2hex(tbcberr, ptr, sizeof(tbcberr) - 1, 0);
 
 		hx = hex_asc_hi(bcberr >> 24);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_lo(bcberr >> 24);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_hi(bcberr >> 16);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_lo(bcberr >> 16);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_hi(bcberr >> 8);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_lo(bcberr >> 8);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_hi(bcberr);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 		hx = hex_asc_lo(bcberr);
-		ptr = pack_hex_byte(ptr, hx);
+		ptr = hex_byte_pack(ptr, hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1321,12 +1321,12 @@ static int gdbstub(struct pt_regs *regs,
 	 * Send trap type (converted to signal)
 	 */
 	*ptr++ = 'T';
-	ptr = pack_hex_byte(ptr, sigval);
+	ptr = hex_byte_pack(ptr, sigval);
 
 	/*
 	 * Send Error PC
 	 */
-	ptr = pack_hex_byte(ptr, GDB_REGID_PC);
+	ptr = hex_byte_pack(ptr, GDB_REGID_PC);
 	*ptr++ = ':';
 	ptr = mem2hex(&regs->pc, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1334,7 +1334,7 @@ static int gdbstub(struct pt_regs *regs,
 	/*
 	 * Send frame pointer
 	 */
-	ptr = pack_hex_byte(ptr, GDB_REGID_FP);
+	ptr = hex_byte_pack(ptr, GDB_REGID_FP);
 	*ptr++ = ':';
 	ptr = mem2hex(&regs->a3, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1343,7 +1343,7 @@ static int gdbstub(struct pt_regs *regs,
 	 * Send stack pointer
 	 */
 	ssp = (unsigned long) (regs + 1);
-	ptr = pack_hex_byte(ptr, GDB_REGID_SP);
+	ptr = hex_byte_pack(ptr, GDB_REGID_SP);
 	*ptr++ = ':';
 	ptr = mem2hex(&ssp, ptr, 4, 0);
 	*ptr++ = ';';
diff -puN kernel/debug/gdbstub.c~kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack kernel/debug/gdbstub.c
--- a/kernel/debug/gdbstub.c~kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack
+++ a/kernel/debug/gdbstub.c
@@ -217,7 +217,7 @@ void gdbstub_msg_write(const char *s, in
 
 		/* Pack in hex chars */
 		for (i = 0; i < wcount; i++)
-			bufptr = pack_hex_byte(bufptr, s[i]);
+			bufptr = hex_byte_pack(bufptr, s[i]);
 		*bufptr = '\0';
 
 		/* Move up */
@@ -249,7 +249,7 @@ char *kgdb_mem2hex(char *mem, char *buf,
 	if (err)
 		return NULL;
 	while (count > 0) {
-		buf = pack_hex_byte(buf, *tmp);
+		buf = hex_byte_pack(buf, *tmp);
 		tmp++;
 		count--;
 	}
@@ -411,14 +411,14 @@ static char *pack_threadid(char *pkt, un
 	limit = id + (BUF_THREAD_ID_SIZE / 2);
 	while (id < limit) {
 		if (!lzero || *id != 0) {
-			pkt = pack_hex_byte(pkt, *id);
+			pkt = hex_byte_pack(pkt, *id);
 			lzero = 0;
 		}
 		id++;
 	}
 
 	if (lzero)
-		pkt = pack_hex_byte(pkt, 0);
+		pkt = hex_byte_pack(pkt, 0);
 
 	return pkt;
 }
@@ -486,7 +486,7 @@ static void gdb_cmd_status(struct kgdb_s
 	dbg_remove_all_break();
 
 	remcom_out_buffer[0] = 'S';
-	pack_hex_byte(&remcom_out_buffer[1], ks->signo);
+	hex_byte_pack(&remcom_out_buffer[1], ks->signo);
 }
 
 static void gdb_get_regs_helper(struct kgdb_state *ks)
@@ -954,7 +954,7 @@ int gdb_serial_stub(struct kgdb_state *k
 		/* Reply to host that an exception has occurred */
 		ptr = remcom_out_buffer;
 		*ptr++ = 'T';
-		ptr = pack_hex_byte(ptr, ks->signo);
+		ptr = hex_byte_pack(ptr, ks->signo);
 		ptr += strlen(strcpy(ptr, "thread:"));
 		int_to_threadref(thref, shadow_pid(current->pid));
 		ptr = pack_threadid(ptr, thref);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch
selinuxfs-remove-custome-hex_to_bin.patch

