From: akpm@linux-foundation.org
Subject: [folded] arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver-fix-2.patch removed from -mm tree
Date: Thu, 28 Jul 2011 13:48:59 -0700
Message-ID: <201107282048.p6SKmxpX007604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755177Ab1G1UtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 16:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Sebastien.Hinderer@ens-lyon.org, lenb@kernel.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     arch-x86-platform-iris-irisc-register-a-platform-device-and-a-plat=
form-driver-fix-2
has been removed from the -mm tree.  Its filename was
     arch-x86-platform-iris-irisc-register-a-platform-device-and-a-plat=
form-driver-fix-2.patch

This patch was dropped because it was folded into arch-x86-platform-iri=
s-irisc-register-a-platform-device-and-a-platform-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: arch-x86-platform-iris-irisc-register-a-platform-device-and-a-=
platform-driver-fix-2
=46rom: Sh=E9rab <Sebastien.Hinderer@ens-lyon.org>

There was one code block that I commented to be able to test the patch =
dnd
then forgot to uncomment again, and then you removed it but it should
actually have been uncommented rather than removed.  So here is the pat=
ch
tat corrects the code, to be applied on top of your own patch.

Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/iris/iris.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/x86/platform/iris/iris.c~arch-x86-platform-iris-irisc-re=
gister-a-platform-device-and-a-platform-driver-fix-2 arch/x86/platform/=
iris/iris.c
--- a/arch/x86/platform/iris/iris.c~arch-x86-platform-iris-irisc-regist=
er-a-platform-device-and-a-platform-driver-fix-2
+++ a/arch/x86/platform/iris/iris.c
@@ -65,6 +65,12 @@ static void iris_power_off(void)
  */
 static int iris_probe(struct platform_device *pdev)
 {
+	unsigned char status =3D inb(IRIS_GIO_INPUT);
+	if (status =3D=3D IRIS_GIO_NODEV) {
+		printk(KERN_ERR "This machine does not seem to be an Iris. "
+			"Power off handler not installed.\n");
+		return -ENODEV;
+	}
 	old_pm_power_off =3D pm_power_off;
 	pm_power_off =3D &iris_power_off;
 	printk(KERN_INFO "Iris power_off handler installed.\n");
_

Patches currently in -mm which might be from Sebastien.Hinderer@ens-lyo=
n.org are

arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-=
driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
