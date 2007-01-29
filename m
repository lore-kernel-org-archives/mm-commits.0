From: akpm@osdl.org
Subject: + drivers-media-video-convert-to-generic-boolean-values.patch added to -mm tree
Date: Sun, 28 Jan 2007 16:02:27 -0800
Message-ID: <200701290002.l0T02RmD006584@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42691 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978AbXA2ACk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 19:02:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se, mchehab@infradead.org


The patch titled
     drivers/media/video: convert to generic boolean-values
has been added to the -mm tree.  Its filename is
     drivers-media-video-convert-to-generic-boolean-values.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: drivers/media/video: convert to generic boolean-values
=46rom: Richard Knutsson <ricknu-0@student.ltu.se>

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/saa5246a.c            |   10 ++--
 drivers/media/video/saa5246a.h            |    9 ----
 drivers/media/video/saa5249.c             |   41 ++++++++------------
 drivers/media/video/saa7134/saa7134-i2c.c |   24 +++++------
 drivers/media/video/saa7134/saa7134.h     |    6 --
 5 files changed, 37 insertions(+), 53 deletions(-)

diff -puN drivers/media/video/saa5246a.c~drivers-media-video-convert-to=
-generic-boolean-values drivers/media/video/saa5246a.c
--- a/drivers/media/video/saa5246a.c~drivers-media-video-convert-to-gen=
eric-boolean-values
+++ a/drivers/media/video/saa5246a.c
@@ -112,7 +112,7 @@ static int saa5246a_attach(struct i2c_ad
 	for (pgbuf =3D 0; pgbuf < NUM_DAUS; pgbuf++)
 	{
 		memset(t->pgbuf[pgbuf], ' ', sizeof(t->pgbuf[0]));
-		t->is_searching[pgbuf] =3D FALSE;
+		t->is_searching[pgbuf] =3D false;
 	}
 	vd->priv=3Dt;
=20
@@ -199,7 +199,7 @@ static int i2c_senddata(struct saa5246a_
=20
 /* Get count number of bytes from I=B2C-device at address adr, store t=
hem in buf.
  * Start & stop handshaking is done by this routine, ack will be sent =
after the
- * last byte to inhibit further sending of data. If uaccess is TRUE, d=
ata is
+ * last byte to inhibit further sending of data. If uaccess is 'true',=
 data is
  * written to user-space with put_user. Returns -1 if I=B2C-device did=
n't send
  * acknowledge, 0 otherwise
  */
@@ -339,7 +339,7 @@ static int saa5246a_request_page(struct=20
 		return -EIO;
 	}
=20
-	t->is_searching[req->pgbuf] =3D TRUE;
+	t->is_searching[req->pgbuf] =3D true;
 	return 0;
 }
=20
@@ -453,7 +453,7 @@ static inline int saa5246a_get_status(st
 		}
 	}
 	if (!info->hamming && !info->notfound)
-		t->is_searching[dau_no] =3D FALSE;
+		t->is_searching[dau_no] =3D false;
 	return 0;
 }
=20
@@ -565,7 +565,7 @@ static inline int saa5246a_stop_dau(stru
 	{
 		return -EIO;
 	}
-	t->is_searching[dau_no] =3D FALSE;
+	t->is_searching[dau_no] =3D false;
 	return 0;
 }
=20
diff -puN drivers/media/video/saa5246a.h~drivers-media-video-convert-to=
-generic-boolean-values drivers/media/video/saa5246a.h
--- a/drivers/media/video/saa5246a.h~drivers-media-video-convert-to-gen=
eric-boolean-values
+++ a/drivers/media/video/saa5246a.h
@@ -41,23 +41,18 @@
 #define POS_HEADER_START 7
 #define POS_HEADER_END 31
=20
-/* Returns TRUE if the part of the videotext page described with req c=
ontains
+/* Returns 'true' if the part of the videotext page described with req=
 contains
    (at least parts of) the time field */
 #define REQ_CONTAINS_TIME(p_req) \
 	((p_req)->start <=3D POS_TIME_END && \
 	 (p_req)->end   >=3D POS_TIME_START)
=20
-/* Returns TRUE if the part of the videotext page described with req c=
ontains
+/* Returns 'true' if the part of the videotext page described with req=
 contains
    (at least parts of) the page header */
 #define REQ_CONTAINS_HEADER(p_req) \
 	((p_req)->start <=3D POS_HEADER_END && \
 	 (p_req)->end   >=3D POS_HEADER_START)
=20
-#ifndef FALSE
-#define FALSE 0
-#define TRUE 1
-#endif
-
 /*********************************************************************=
********/
 /* Mode register numbers of the SAA5246A				     */
 /*********************************************************************=
********/
diff -puN drivers/media/video/saa5249.c~drivers-media-video-convert-to-=
generic-boolean-values drivers/media/video/saa5249.c
--- a/drivers/media/video/saa5249.c~drivers-media-video-convert-to-gene=
ric-boolean-values
+++ a/drivers/media/video/saa5249.c
@@ -124,11 +124,6 @@ struct saa5249_device
=20
 /* General defines and debugging support */
=20
-#ifndef FALSE
-#define FALSE 0
-#define TRUE 1
-#endif
-
 #define RESCHED do { cond_resched(); } while(0)
=20
 static struct video_device saa_template;	/* Declared near bottom */
@@ -183,9 +178,9 @@ static int saa5249_attach(struct i2c_ada
 		memset(t->vdau[pgbuf].sregs, 0, sizeof(t->vdau[0].sregs));
 		memset(t->vdau[pgbuf].laststat, 0, sizeof(t->vdau[0].laststat));
 		t->vdau[pgbuf].expire =3D 0;
-		t->vdau[pgbuf].clrfound =3D TRUE;
-		t->vdau[pgbuf].stopped =3D TRUE;
-		t->is_searching[pgbuf] =3D FALSE;
+		t->vdau[pgbuf].clrfound =3D true;
+		t->vdau[pgbuf].stopped =3D true;
+		t->is_searching[pgbuf] =3D false;
 	}
 	vd->priv=3Dt;
=20
@@ -298,7 +293,7 @@ static int i2c_senddata(struct saa5249_d
=20
 /* Get count number of bytes from I=B2C-device at address adr, store t=
hem in buf. Start & stop
  * handshaking is done by this routine, ack will be sent after the las=
t byte to inhibit further
- * sending of data. If uaccess is TRUE, data is written to user-space =
with put_user.
+ * sending of data. If uaccess is 'true', data is written to user-spac=
e with put_user.
  * Returns -1 if I=B2C-device didn't send acknowledge, 0 otherwise
  */
=20
@@ -317,7 +312,7 @@ static int i2c_getdata(struct saa5249_de
 static int do_saa5249_ioctl(struct inode *inode, struct file *file,
 			    unsigned int cmd, void *arg)
 {
-	static int virtual_mode =3D FALSE;
+	static int virtual_mode =3D false;
 	struct video_device *vd =3D video_devdata(file);
 	struct saa5249_device *t=3Dvd->priv;
=20
@@ -340,7 +335,7 @@ static int do_saa5249_ioctl(struct inode
 			if (req->pgbuf < 0 || req->pgbuf >=3D NUM_DAUS)
 				return -EINVAL;
 			memset(t->vdau[req->pgbuf].pgbuf, ' ', sizeof(t->vdau[0].pgbuf));
-			t->vdau[req->pgbuf].clrfound =3D TRUE;
+			t->vdau[req->pgbuf].clrfound =3D true;
 			return 0;
 		}
=20
@@ -350,7 +345,7 @@ static int do_saa5249_ioctl(struct inode
=20
 			if (req->pgbuf < 0 || req->pgbuf >=3D NUM_DAUS)
 				return -EINVAL;
-			t->vdau[req->pgbuf].clrfound =3D TRUE;
+			t->vdau[req->pgbuf].clrfound =3D true;
 			return 0;
 		}
=20
@@ -376,9 +371,9 @@ static int do_saa5249_ioctl(struct inode
 			t->vdau[req->pgbuf].sregs[4] =3D (req->pagemask & HR_UNIT ? 0x10 : =
0) | (req->hour & 0xf);
 			t->vdau[req->pgbuf].sregs[5] =3D (req->pagemask & MIN_TEN ? 0x10 : =
0) | (req->minute / 0x10);
 			t->vdau[req->pgbuf].sregs[6] =3D (req->pagemask & MIN_UNIT ? 0x10 :=
 0) | (req->minute & 0xf);
-			t->vdau[req->pgbuf].stopped =3D FALSE;
-			t->vdau[req->pgbuf].clrfound =3D TRUE;
-			t->is_searching[req->pgbuf] =3D TRUE;
+			t->vdau[req->pgbuf].stopped =3D false;
+			t->vdau[req->pgbuf].clrfound =3D true;
+			t->is_searching[req->pgbuf] =3D true;
 			return 0;
 		}
=20
@@ -430,7 +425,7 @@ static int do_saa5249_ioctl(struct inode
 							i2c_getdata(t, 40, t->vdau[req->pgbuf].pgbuf + VTX_PAGESIZE + 2=
3 * 40))
 							return -EIO;
 					}
-					t->vdau[req->pgbuf].clrfound =3D FALSE;
+					t->vdau[req->pgbuf].clrfound =3D false;
 					memcpy(t->vdau[req->pgbuf].laststat, infobits, sizeof(infobits));
 				}
 				else
@@ -474,7 +469,7 @@ static int do_saa5249_ioctl(struct inode
 				return -EFAULT;
 			if (!info.hamming && !info.notfound)
 			{
-				t->is_searching[req->pgbuf] =3D FALSE;
+				t->is_searching[req->pgbuf] =3D false;
 			}
 			return 0;
 		}
@@ -530,8 +525,8 @@ static int do_saa5249_ioctl(struct inode
=20
 			if (req->pgbuf < 0 || req->pgbuf >=3D NUM_DAUS)
 				return -EINVAL;
-			t->vdau[req->pgbuf].stopped =3D TRUE;
-			t->is_searching[req->pgbuf] =3D FALSE;
+			t->vdau[req->pgbuf].stopped =3D true;
+			t->is_searching[req->pgbuf] =3D false;
 			return 0;
 		}
=20
@@ -660,11 +655,11 @@ static int saa5249_open(struct inode *in
 		memset(t->vdau[pgbuf].sregs, 0, sizeof(t->vdau[0].sregs));
 		memset(t->vdau[pgbuf].laststat, 0, sizeof(t->vdau[0].laststat));
 		t->vdau[pgbuf].expire =3D 0;
-		t->vdau[pgbuf].clrfound =3D TRUE;
-		t->vdau[pgbuf].stopped =3D TRUE;
-		t->is_searching[pgbuf] =3D FALSE;
+		t->vdau[pgbuf].clrfound =3D true;
+		t->vdau[pgbuf].stopped =3D true;
+		t->is_searching[pgbuf] =3D false;
 	}
-	t->virtual_mode=3DFALSE;
+	t->virtual_mode =3D false;
 	return 0;
=20
  fail:
diff -puN drivers/media/video/saa7134/saa7134.h~drivers-media-video-con=
vert-to-generic-boolean-values drivers/media/video/saa7134/saa7134.h
--- a/drivers/media/video/saa7134/saa7134.h~drivers-media-video-convert=
-to-generic-boolean-values
+++ a/drivers/media/video/saa7134/saa7134.h
@@ -43,12 +43,6 @@
 #include <sound/pcm.h>
 #include <media/video-buf-dvb.h>
=20
-#ifndef TRUE
-# define TRUE (1=3D=3D1)
-#endif
-#ifndef FALSE
-# define FALSE (1=3D=3D0)
-#endif
 #define UNSET (-1U)
=20
 /* ----------------------------------------------------------- */
diff -puN drivers/media/video/saa7134/saa7134-i2c.c~drivers-media-video=
-convert-to-generic-boolean-values drivers/media/video/saa7134/saa7134-=
i2c.c
--- a/drivers/media/video/saa7134/saa7134-i2c.c~drivers-media-video-con=
vert-to-generic-boolean-values
+++ a/drivers/media/video/saa7134/saa7134-i2c.c
@@ -120,9 +120,9 @@ static inline int i2c_is_error(enum i2c_
 	case ARB_LOST:
 	case SEQ_ERR:
 	case ST_ERR:
-		return TRUE;
+		return true;
 	default:
-		return FALSE;
+		return false;
 	}
 }
=20
@@ -131,9 +131,9 @@ static inline int i2c_is_idle(enum i2c_s
 	switch (status) {
 	case IDLE:
 	case DONE_STOP:
-		return TRUE;
+		return true;
 	default:
-		return FALSE;
+		return false;
 	}
 }
=20
@@ -141,9 +141,9 @@ static inline int i2c_is_busy(enum i2c_s
 {
 	switch (status) {
 	case BUSY:
-		return TRUE;
+		return true;
 	default:
-		return FALSE;
+		return false;
 	}
 }
=20
@@ -159,8 +159,8 @@ static int i2c_is_busy_wait(struct saa71
 		saa_wait(I2C_WAIT_DELAY);
 	}
 	if (I2C_WAIT_RETRY =3D=3D count)
-		return FALSE;
-	return TRUE;
+		return false;
+	return true;
 }
=20
 static int i2c_reset(struct saa7134_dev *dev)
@@ -171,7 +171,7 @@ static int i2c_reset(struct saa7134_dev=20
 	d2printk(KERN_DEBUG "%s: i2c reset\n",dev->name);
 	status =3D i2c_get_status(dev);
 	if (!i2c_is_error(status))
-		return TRUE;
+		return true;
 	i2c_set_status(dev,status);
=20
 	for (count =3D 0; count < I2C_WAIT_RETRY; count++) {
@@ -181,13 +181,13 @@ static int i2c_reset(struct saa7134_dev=20
 		udelay(I2C_WAIT_DELAY);
 	}
 	if (I2C_WAIT_RETRY =3D=3D count)
-		return FALSE;
+		return false;
=20
 	if (!i2c_is_idle(status))
-		return FALSE;
+		return false;
=20
 	i2c_set_attr(dev,NOP);
-	return TRUE;
+	return true;
 }
=20
 static inline int i2c_send_byte(struct saa7134_dev *dev,
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se ar=
e

drivers-media-video-convert-to-generic-boolean-values.patch
hp100-convert-pci_module_init-to-pci_register_driver.patch
drivers-scsi-buslogic-replace-boolean-by-bool.patch
git-cryptodev.patch
drivers-block-dac960-converted-boolean-to-bool.patch
