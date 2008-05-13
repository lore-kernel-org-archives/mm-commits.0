From: akpm@linux-foundation.org
Subject: + cris-use-the-common-ascii-hex-helpers.patch added to -mm tree
Date: Mon, 12 May 2008 17:31:47 -0700
Message-ID: <200805130031.m4D0Vl7l016792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbYEMAby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 20:31:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, starvik@axis.com


The patch titled
     cris: use the common ascii hex helpers
has been added to the -mm tree.  Its filename is
     cris-use-the-common-ascii-hex-helpers.patch

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
Subject: cris: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/kgdb.c |   79 ++++++++---------------------
 arch/cris/arch-v32/kernel/kgdb.c |   60 ++++------------------
 2 files changed, 37 insertions(+), 102 deletions(-)

diff -puN arch/cris/arch-v10/kernel/kgdb.c~cris-use-the-common-ascii-hex-helpers arch/cris/arch-v10/kernel/kgdb.c
--- a/arch/cris/arch-v10/kernel/kgdb.c~cris-use-the-common-ascii-hex-helpers
+++ a/arch/cris/arch-v10/kernel/kgdb.c
@@ -278,14 +278,6 @@ void putDebugChar (int val);
 
 void enableDebugIRQ (void);
 
-/* Returns the character equivalent of a nibble, bit 7, 6, 5, and 4 of a byte,
-   represented by int x. */
-static char highhex (int x);
-
-/* Returns the character equivalent of a nibble, bit 3, 2, 1, and 0 of a byte,
-   represented by int x. */
-static char lowhex (int x);
-
 /* Returns the integer equivalent of a hexadecimal character. */
 static int hex (char ch);
 
@@ -356,9 +348,6 @@ extern unsigned char executing_task;
 /* Run-length encoding maximum length. Send 64 at most. */
 #define RUNLENMAX 64
 
-/* Definition of all valid hexadecimal characters */
-static const char hexchars[] = "0123456789abcdef";
-
 /* The inbound/outbound buffers used in packet I/O */
 static char remcomInBuffer[BUFMAX];
 static char remcomOutBuffer[BUFMAX];
@@ -499,8 +488,8 @@ gdb_cris_strtol (const char *s, char **e
 	char *sd;
 	int x = 0;
 	
-	for (s1 = (char*)s; (sd = gdb_cris_memchr(hexchars, *s1, base)) != NULL; ++s1)
-		x = x * base + (sd - hexchars);
+	for (s1 = (char*)s; (sd = gdb_cris_memchr(hex_asc, *s1, base)) != NULL; ++s1)
+		x = x * base + (sd - hex_asc);
         
         if (endptr)
         {
@@ -670,22 +659,6 @@ read_register (char regno, unsigned int 
 }
 
 /********************************** Packet I/O ******************************/
-/* Returns the character equivalent of a nibble, bit 7, 6, 5, and 4 of a byte,
-   represented by int x. */
-static inline char
-highhex(int x)
-{
-	return hexchars[(x >> 4) & 0xf];
-}
-
-/* Returns the character equivalent of a nibble, bit 3, 2, 1, and 0 of a byte,
-   represented by int x. */
-static inline char
-lowhex(int x)
-{
-	return hexchars[x & 0xf];
-}
-
 /* Returns the integer equivalent of a hexadecimal character. */
 static int
 hex (char ch)
@@ -721,8 +694,7 @@ mem2hex(char *buf, unsigned char *mem, i
                 /* Valid mem address. */
                 for (i = 0; i < count; i++) {
                         ch = *mem++;
-                        *buf++ = highhex (ch);
-                        *buf++ = lowhex (ch);
+			buf = pack_hex_byte(buf, ch);
                 }
         }
         
@@ -857,9 +829,9 @@ putpacket(char *buffer)
 				src++;
 			}
 		}
-		putDebugChar ('#');
-		putDebugChar (highhex (checksum));
-		putDebugChar (lowhex (checksum));
+		putDebugChar('#');
+		putDebugChar(hex_asc_hi(checksum));
+		putDebugChar(hex_asc_lo(checksum));
 	} while(kgdb_started && (getDebugChar() != '+'));
 }
 
@@ -895,9 +867,8 @@ stub_is_stopped(int sigval)
         
 	/* Send trap type (converted to signal) */
 
-	*ptr++ = 'T';	
-	*ptr++ = highhex (sigval);
-	*ptr++ = lowhex (sigval);
+	*ptr++ = 'T';
+	ptr = pack_hex_byte(ptr, sigval);
 
 	/* Send register contents. We probably only need to send the
 	 * PC, frame pointer and stack pointer here. Other registers will be
@@ -910,9 +881,7 @@ stub_is_stopped(int sigval)
                 status = read_register (regno, &reg_cont);
                 
 		if (status == SUCCESS) {
-                        
-                        *ptr++ = highhex (regno);
-                        *ptr++ = lowhex (regno);
+			ptr = pack_hex_byte(ptr, regno);
                         *ptr++ = ':';
 
                         ptr = mem2hex(ptr, (unsigned char *)&reg_cont,
@@ -937,8 +906,8 @@ stub_is_stopped(int sigval)
 	/* Store thread:r...; with the executing task TID. */
 	gdb_cris_strcpy (&remcomOutBuffer[pos], "thread:");
 	pos += gdb_cris_strlen ("thread:");
-	remcomOutBuffer[pos++] = highhex (executing_task);
-	remcomOutBuffer[pos++] = lowhex (executing_task);
+	remcomOutBuffer[pos++] = hex_asc_hi(executing_task);
+	remcomOutBuffer[pos++] = hex_asc_lo(executing_task);
 	gdb_cris_strcpy (&remcomOutBuffer[pos], ";");
 #endif
 
@@ -1126,8 +1095,8 @@ handle_exception (int sigval)
 				   Success: SAA, where AA is the signal number.
 				   Failure: void. */
 				remcomOutBuffer[0] = 'S';
-				remcomOutBuffer[1] = highhex (sigval);
-				remcomOutBuffer[2] = lowhex (sigval);
+				remcomOutBuffer[1] = hex_asc_hi(sigval);
+				remcomOutBuffer[2] = hex_asc_lo(sigval);
 				remcomOutBuffer[3] = 0;
 				break;
 				
@@ -1224,23 +1193,23 @@ handle_exception (int sigval)
 						case 'C':
 							/* Identify the remote current thread. */
 							gdb_cris_strcpy (&remcomOutBuffer[0], "QC");
-							remcomOutBuffer[2] = highhex (current_thread_c);
-							remcomOutBuffer[3] = lowhex (current_thread_c);
+							remcomOutBuffer[2] = hex_asc_hi(current_thread_c);
+							remcomOutBuffer[3] = hex_asc_lo(current_thread_c);
 							remcomOutBuffer[4] = '\0';
 							break;
 						case 'L':
 							gdb_cris_strcpy (&remcomOutBuffer[0], "QM");
 							/* Reply with number of threads. */
 							if (os_is_started()) {
-								remcomOutBuffer[2] = highhex (number_of_tasks);
-								remcomOutBuffer[3] = lowhex (number_of_tasks);
+								remcomOutBuffer[2] = hex_asc_hi(number_of_tasks);
+								remcomOutBuffer[3] = hex_asc_lo(number_of_tasks);
 							}
 							else {
-								remcomOutBuffer[2] = highhex (0);
-								remcomOutBuffer[3] = lowhex (1);
+								remcomOutBuffer[2] = hex_asc_hi(0);
+								remcomOutBuffer[3] = hex_asc_lo(1);
 							}
 							/* Done with the reply. */
-							remcomOutBuffer[4] = lowhex (1);
+							remcomOutBuffer[4] = hex_asc_lo(1);
 							pos = 5;
 							/* Expects the argument thread id. */
 							for (; pos < (5 + HEXCHARS_IN_THREAD_ID); pos++)
@@ -1251,16 +1220,16 @@ handle_exception (int sigval)
 								for (thread_id = 0; thread_id < number_of_tasks; thread_id++) {
 									nextpos = pos + HEXCHARS_IN_THREAD_ID - 1;
 									for (; pos < nextpos; pos ++)
-										remcomOutBuffer[pos] = lowhex (0);
-									remcomOutBuffer[pos++] = lowhex (thread_id);
+										remcomOutBuffer[pos] = hex_asc_lo(0);
+									remcomOutBuffer[pos++] = hex_asc_lo(thread_id);
 								}
 							}
 							else {
 								/* Store the thread identifier of the boot task. */
 								nextpos = pos + HEXCHARS_IN_THREAD_ID - 1;
 								for (; pos < nextpos; pos ++)
-									remcomOutBuffer[pos] = lowhex (0);
-								remcomOutBuffer[pos++] = lowhex (current_thread_c);
+									remcomOutBuffer[pos] = hex_asc_lo(0);
+								remcomOutBuffer[pos++] = hex_asc_lo(current_thread_c);
 							}
 							remcomOutBuffer[pos] = '\0';
 							break;
diff -puN arch/cris/arch-v32/kernel/kgdb.c~cris-use-the-common-ascii-hex-helpers arch/cris/arch-v32/kernel/kgdb.c
--- a/arch/cris/arch-v32/kernel/kgdb.c~cris-use-the-common-ascii-hex-helpers
+++ a/arch/cris/arch-v32/kernel/kgdb.c
@@ -398,14 +398,6 @@ void putDebugChar(int val)
 }
 #endif
 
-/* Returns the character equivalent of a nibble, bit 7, 6, 5, and 4 of a byte,
-   represented by int x. */
-static char highhex(int x);
-
-/* Returns the character equivalent of a nibble, bit 3, 2, 1, and 0 of a byte,
-   represented by int x. */
-static char lowhex(int x);
-
 /* Returns the integer equivalent of a hexadecimal character. */
 static int hex(char ch);
 
@@ -464,9 +456,6 @@ void breakpoint(void);
 /* Run-length encoding maximum length. Send 64 at most. */
 #define RUNLENMAX 64
 
-/* Definition of all valid hexadecimal characters */
-static const char hexchars[] = "0123456789abcdef";
-
 /* The inbound/outbound buffers used in packet I/O */
 static char input_buffer[BUFMAX];
 static char output_buffer[BUFMAX];
@@ -550,8 +539,8 @@ gdb_cris_strtol(const char *s, char **en
 	char *sd;
 	int x = 0;
 
-	for (s1 = (char*)s; (sd = gdb_cris_memchr(hexchars, *s1, base)) != NULL; ++s1)
-		x = x * base + (sd - hexchars);
+	for (s1 = (char*)s; (sd = gdb_cris_memchr(hex_asc, *s1, base)) != NULL; ++s1)
+		x = x * base + (sd - hex_asc);
 
         if (endptr) {
                 /* Unconverted suffix is stored in endptr unless endptr is NULL. */
@@ -655,22 +644,6 @@ read_register(char regno, unsigned int *
 }
 
 /********************************** Packet I/O ******************************/
-/* Returns the character equivalent of a nibble, bit 7, 6, 5, and 4 of a byte,
-   represented by int x. */
-static inline char
-highhex(int x)
-{
-	return hexchars[(x >> 4) & 0xf];
-}
-
-/* Returns the character equivalent of a nibble, bit 3, 2, 1, and 0 of a byte,
-   represented by int x. */
-static inline char
-lowhex(int x)
-{
-	return hexchars[x & 0xf];
-}
-
 /* Returns the integer equivalent of a hexadecimal character. */
 static int
 hex(char ch)
@@ -704,8 +677,7 @@ mem2hex(char *buf, unsigned char *mem, i
                 /* Valid mem address. */
 		for (i = 0; i < count; i++) {
 			ch = *mem++;
-			*buf++ = highhex (ch);
-			*buf++ = lowhex (ch);
+			buf = pack_hex_byte(buf, ch);
 		}
         }
         /* Terminate properly. */
@@ -723,8 +695,7 @@ mem2hex_nbo(char *buf, unsigned char *me
 	mem += count - 1;
 	for (i = 0; i < count; i++) {
 		ch = *mem--;
-		*buf++ = highhex (ch);
-		*buf++ = lowhex (ch);
+		buf = pack_hex_byte(buf, ch);
         }
 
         /* Terminate properly. */
@@ -862,8 +833,8 @@ putpacket(char *buffer)
 			}
 		}
 		putDebugChar('#');
-		putDebugChar(highhex (checksum));
-		putDebugChar(lowhex (checksum));
+		putDebugChar(hex_asc_hi(checksum));
+		putDebugChar(hex_asc_lo(checksum));
 	} while(kgdb_started && (getDebugChar() != '+'));
 }
 
@@ -909,8 +880,7 @@ stub_is_stopped(int sigval)
 	/* Send trap type (converted to signal) */
 
 	*ptr++ = 'T';
-	*ptr++ = highhex(sigval);
-	*ptr++ = lowhex(sigval);
+	ptr = pack_hex_byte(ptr, sigval);
 
 	if (((reg.exs & 0xff00) >> 8) == 0xc) {
 
@@ -1018,30 +988,26 @@ stub_is_stopped(int sigval)
 	}
 	/* Only send PC, frame and stack pointer. */
 	read_register(PC, &reg_cont);
-	*ptr++ = highhex(PC);
-	*ptr++ = lowhex(PC);
+	ptr = pack_hex_byte(PC);
 	*ptr++ = ':';
 	ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[PC]);
 	*ptr++ = ';';
 
 	read_register(R8, &reg_cont);
-	*ptr++ = highhex(R8);
-	*ptr++ = lowhex(R8);
+	ptr = pack_hex_byte(R8);
 	*ptr++ = ':';
 	ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[R8]);
 	*ptr++ = ';';
 
 	read_register(SP, &reg_cont);
-	*ptr++ = highhex(SP);
-	*ptr++ = lowhex(SP);
+	ptr = pack_hex_byte(SP);
 	*ptr++ = ':';
 	ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[SP]);
 	*ptr++ = ';';
 
 	/* Send ERP as well; this will save us an entire register fetch in some cases. */
         read_register(ERP, &reg_cont);
-        *ptr++ = highhex(ERP);
-        *ptr++ = lowhex(ERP);
+	ptr = pack_hex_byte(ERP);
         *ptr++ = ':';
         ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[ERP]);
         *ptr++ = ';';
@@ -1533,8 +1499,8 @@ handle_exception(int sigval)
 				   Success: SAA, where AA is the signal number.
 				   Failure: void. */
 				output_buffer[0] = 'S';
-				output_buffer[1] = highhex(sigval);
-				output_buffer[2] = lowhex(sigval);
+				output_buffer[1] = hex_asc_hi(sigval);
+				output_buffer[2] = hex_asc_lo(sigval);
 				output_buffer[3] = 0;
 				break;
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

mmc-make-one-bit-signed-bitfields-unsigned.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
wireless-use-get-put_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
lib-create-common-ascii-hex-array.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
sh-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
aacraid-linitc-make-aac_show_serial_number-static.patch

