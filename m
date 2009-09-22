From: akpm@linux-foundation.org
Subject: [wrecked] tpm-fix-up-pubek-sysfs-file.patch removed from -mm tree
Date: Tue, 22 Sep 2009 16:17:53 -0700
Message-ID: <200909222317.n8MNHref024515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752788AbZIVXSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 19:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jgunthorpe@obsidianresearch.com, debora@linux.vnet.ibm.com, jmorris@namei.org, m.selhorst@sirrix.com, srajiv@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tpm: fix up pubek sysfs file
has been removed from the -mm tree.  Its filename was
     tpm-fix-up-pubek-sysfs-file.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: fix up pubek sysfs file
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

tpm_show_pubek is utterly and completely wrong, all the offsets into the
binary blob are wrong, the output is garbage.  Do it again.

Before:
Algorithm: 00 0C 00 00
Encscheme: 08 00
Sigscheme: 00 00
Parameters: 00 00 00 00 01 00 AF 6B 30 9B 0D B3
Modulus length: -1266846667
Modulus:
68 45 8D CA A5 EF A8 8A DD 0F D7 84 8E 8D 1F 40
22 92 09 CF 12 C8 9F 6E 55 57 6A 2C A8 0B 5E 45
C7 5E 3D 56 DA 64 E6 E1 F7 8C DD 41 92 28 2E 06
41 02 3E 11 7D B2 C5 46 38 E5 8C 60 D2 96 EE 0C
D6 3D F8 99 E3 02 3A 32 7A 02 C8 31 29 98 28 B9
1B EF 30 A1 A0 45 A0 C0 05 0E C5 96 95 FD 91 47
0A 35 E0 69 B0 8B 49 BD B9 F6 5D 25 21 25 79 1B
20 0D C3 C7 1F 87 5E 5F 41 4B DE 32 DF 55 F3 BD
7F CA D8 7D 3A B4 D5 0A EF CF 8E 72 20 52 15 FA
FB C6 C0 2E C2 AB C6 07 D0 9D 96 6B 2E 30 F7 54
C4 A5 CD 9B 13 54 A0 D1 71 66 91 97 06 12 B5 2D
B2 33 62 FB 56 62 64 A8 AA E9 F2 F4 03 C3 F4 49
2A 09 0D 7D 75 99 6C F0 47 1E 7D D5 A5 CA CE EF
45 B2 DA 88 93 B4 EE EB FB B0 A6 A4 19 C4 B8 0D
04 46 AE BD C5 2E 30 84 49 57 25 34 78 E6 ED C4
50 AF 3B F6 86 43 54 0A D9 DB 54 9C 06 B3 50 7F

After:
Algorithm: 00 00 00 01
Encscheme: 00 03
Sigscheme: 00 01
Parameters: 00 00 08 00 00 00 00 02 00 00 00 00
Modulus length: 256
Modulus:
AF 6B 30 9B 0D B3 B4 7D 74 35 68 45 8D CA A5 EF
A8 8A DD 0F D7 84 8E 8D 1F 40 22 92 09 CF 12 C8
9F 6E 55 57 6A 2C A8 0B 5E 45 C7 5E 3D 56 DA 64
E6 E1 F7 8C DD 41 92 28 2E 06 41 02 3E 11 7D B2
C5 46 38 E5 8C 60 D2 96 EE 0C D6 3D F8 99 E3 02
3A 32 7A 02 C8 31 29 98 28 B9 1B EF 30 A1 A0 45
A0 C0 05 0E C5 96 95 FD 91 47 0A 35 E0 69 B0 8B
49 BD B9 F6 5D 25 21 25 79 1B 20 0D C3 C7 1F 87
5E 5F 41 4B DE 32 DF 55 F3 BD 7F CA D8 7D 3A B4
D5 0A EF CF 8E 72 20 52 15 FA FB C6 C0 2E C2 AB
C6 07 D0 9D 96 6B 2E 30 F7 54 C4 A5 CD 9B 13 54
A0 D1 71 66 91 97 06 12 B5 2D B2 33 62 FB 56 62
64 A8 AA E9 F2 F4 03 C3 F4 49 2A 09 0D 7D 75 99
6C F0 47 1E 7D D5 A5 CA CE EF 45 B2 DA 88 93 B4
EE EB FB B0 A6 A4 19 C4 B8 0D 04 46 AE BD C5 2E
30 84 49 57 25 34 78 E6 ED C4 50 AF 3B F6 86 43

I've checked this decoded output in two different ways.

Tested on a winbond WPCT200

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |   77 ++++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 24 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-fix-up-pubek-sysfs-file drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-fix-up-pubek-sysfs-file
+++ a/drivers/char/tpm/tpm.c
@@ -460,6 +460,11 @@ static ssize_t transmit_cmd(struct tpm_c
 		dev_dbg(chip->dev, "A TPM error (%d) occurred %s\n", err, desc);
 		return err;
 	}
+	if (len != be32_to_cpu(cmd->header.out.length)) {
+		dev_dbg(chip->dev, "TPM returned the wrong length %x %x\n",
+			len, be32_to_cpu(cmd->header.out.length));
+		return -1;
+	}
 	return 0;
 }
 
@@ -811,43 +816,67 @@ ssize_t tpm_show_pubek(struct device *de
 {
 	u8 *data;
 	struct tpm_cmd_t tpm_cmd;
-	ssize_t err;
-	int i, rc;
+	ssize_t len;
+	int i, rc, key_len;
 	char *str = buf;
 
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
 	tpm_cmd.header.in = tpm_readpubek_header;
-	err = transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
-			"attempting to read the PUBEK");
-	if (err)
+	if (transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
+			 "attempting to read the PUBEK"))
+		goto out;
+
+	len = be32_to_cpu(tpm_cmd.header.out.length);
+	if (len <= 0)
 		goto out;
 
-	/* 
-	   ignore header 10 bytes
-	   algorithm 32 bits (1 == RSA )
-	   encscheme 16 bits
-	   sigscheme 16 bits
-	   parameters (RSA 12->bytes: keybit, #primes, expbit)  
-	   keylenbytes 32 bits
-	   256 byte modulus
-	   ignore checksum 20 bytes
+	/* Format (in bytes):
+	     10 RPC Header (tpm_cmd.header)
+	     xx TPM_PUBKEY pubEK
+		xx TPM_KEY_PARMS
+		  4 algorithmID
+		  2 encScheme
+		  2 sigcScheme
+		  4 parmSize
+		  xx parms (typically 12 bytes for a RSA key)
+		xx TPM_STORE_PUBKEY
+		  4 keyLength
+		  xx key (typically 256 for a RSA key)
+	     20 TPM_DIGEST checksum
 	 */
 	data = tpm_cmd.params.readpubek_out_buffer;
+	len -= 10;
+	if (len < 24)
+		goto out;
 	str +=
 	    sprintf(str,
 		    "Algorithm: %02X %02X %02X %02X\nEncscheme: %02X %02X\n"
 		    "Sigscheme: %02X %02X\nParameters: %02X %02X %02X %02X"
-		    " %02X %02X %02X %02X %02X %02X %02X %02X\n"
-		    "Modulus length: %d\nModulus: \n",
-		    data[10], data[11], data[12], data[13], data[14],
-		    data[15], data[16], data[17], data[22], data[23],
-		    data[24], data[25], data[26], data[27], data[28],
-		    data[29], data[30], data[31], data[32], data[33],
-		    be32_to_cpu(*((__be32 *) (data + 34))));
-
-	for (i = 0; i < 256; i++) {
-		str += sprintf(str, "%02X ", data[i + 38]);
+		    " %02X %02X %02X %02X %02X %02X %02X %02X\n",
+		    data[0], data[1], data[2], data[3],
+		    data[4], data[5],
+		    data[6], data[7],
+		    data[12], data[13], data[14], data[15], data[16], data[17],
+		    data[18], data[19], data[20], data[21], data[22], data[23]);
+	/* Skip TPM_KEY_PARMS.parms and TPM_STORE_PBUKEY.keyLength */
+	i = 4 + 2 + 2 + 4 + be32_to_cpu(*((__be32 *) (data + 8))) + 4;
+	if (i > len)
+		goto out;
+	data += i;
+	len -= i;
+	key_len = be32_to_cpu(*((__be32 *) (data) - 1));
+
+	/* Note: The value printed here is the TPM_STORE_PUBKEY. For RSA keys
+	   this is a modulus, but it can vary for other key types. */
+	str += sprintf(str, "Modulus length: %d\nModulus: \n", key_len);
+
+	/* len is bounded, so key_len is bounded, so sprintf is bounded, so
+	   str doesn't overflow. Well, maybe. */
+	if (key_len > len)
+		goto out;
+	for (i = 0; i < key_len; i++) {
+		str += sprintf(str, "%02X ", data[i]);
 		if ((i + 1) % 16 == 0)
 			str += sprintf(str, "\n");
 	}
_

Patches currently in -mm which might be from jgunthorpe@obsidianresearch.com are

origin.patch
linux-next.patch
tpm-fix-up-pubek-sysfs-file.patch

