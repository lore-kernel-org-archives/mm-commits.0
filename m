From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-add-%pu-to-print-uuid-guids.patch added to -mm tree
Date: Tue, 13 Oct 2009 14:49:58 -0700
Message-ID: <200910132149.n9DLnwi2025934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbZJMVwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 17:52:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, adrian.hunter@nokia.com, aelder@sgi.com, dedekind@infradead.org, hch@lst.de, jgarzik@redhat.com, mchehab@infradead.org, mpm@selenic.com, neilb@suse.de, swhiteho@redhat.com, tj@kernel.org


The patch titled
     lib/vsprintf.c: add %pU to print UUID/GUIDs
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-add-%pu-to-print-uuid-guids.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lib/vsprintf.c: add %pU to print UUID/GUIDs
=46rom: Joe Perches <joe@perches.com>

UUID/GUIDs are somewhat common in kernel source.

Standardize the printed style of UUID/GUIDs by using
another extension to %p.

%pUb:   01020304-0506-0708-090a-0b0c0d0e0f10
%pUB:   01020304-0506-0708-090A-0B0C0D0E0F10 (upper case)
%pUl:   04030201-0605-0807-090a-0b0c0d0e0f10
%pUL:   04030201-0605-0807-090A-0B0C0D0E0F10 (upper case)

%pU defaults to %pUb

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN lib/vsprintf.c~lib-vsprintfc-add-%pu-to-print-uuid-guids lib/=
vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-add-%pu-to-print-uuid-guids
+++ a/lib/vsprintf.c
@@ -790,6 +790,52 @@ static char *ip4_addr_string(char *buf,=20
 	return string(buf, end, ip4_addr, spec);
 }
=20
+static char *uuid_string(char *buf, char *end, const u8 *addr,
+			 struct printf_spec spec, const char *fmt)
+{
+	char uuid[sizeof("xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")];
+	char *p =3D uuid;
+	int i;
+	static const u8 be[16] =3D {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
+	static const u8 le[16] =3D {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
+	const u8 *index =3D be;
+	bool uc =3D false;
+
+	switch (*(++fmt)) {
+	case 'L':
+		uc =3D true;		/* fall-through */
+	case 'l':
+		index =3D le;
+		break;
+	case 'B':
+		uc =3D true;
+		break;
+	}
+
+	for (i =3D 0; i < 16; i++) {
+		p =3D pack_hex_byte(p, addr[index[i]]);
+		switch (i) {
+		case 3:
+		case 5:
+		case 7:
+		case 9:
+			*p++ =3D '-';
+			break;
+		}
+	}
+
+	*p =3D 0;
+
+	if (uc) {
+		p =3D uuid;
+		do {
+			*p =3D toupper(*p);
+		} while (*(++p));
+	}
+
+	return string(buf, end, uuid, spec);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -814,6 +860,18 @@ static char *ip4_addr_string(char *buf,=20
  *       IPv4 uses dot-separated decimal with leading 0's (010.123.045=
=2E006)
  * - 'I6c' for IPv6 addresses printed as specified by
  *       http://www.ietf.org/id/draft-kawamura-ipv6-text-representatio=
n-03.txt
+ * - 'U' For a 16 byte UUID/GUID, it prints the UUID/GUID in the form
+ *       "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
+ *       Options for %pU are:
+ *         b big endian lower case hex (default)
+ *         B big endian UPPER case hex
+ *         l little endian lower case hex
+ *         L little endian UPPER case hex
+ *           big endian output byte order is:
+ *             [0][1][2][3]-[4][5]-[6][7]-[8][9]-[10][11][12][13][14][=
15]
+ *           little endian output byte order is:
+ *             [3][2][1][0]-[5][4]-[7][6]-[8][9]-[10][11][12][13][14][=
15]
+ *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
@@ -828,9 +886,9 @@ static char *pointer(const char *fmt, ch
 	case 'F':
 	case 'f':
 		ptr =3D dereference_function_descriptor(ptr);
-	case 's':
 		/* Fallthrough */
 	case 'S':
+	case 's':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 		return resource_string(buf, end, ptr, spec);
@@ -853,6 +911,8 @@ static char *pointer(const char *fmt, ch
 			return ip4_addr_string(buf, end, ptr, spec, fmt);
 		}
 		break;
+	case 'U':
+		return uuid_string(buf, end, ptr, spec, fmt);
 	}
 	spec.flags |=3D SMALL;
 	if (spec.field_width =3D=3D -1) {
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-update-generic-uio-for-pci-devices.patch
maintainers-update-tracing-section.patch
maintainers-update-omap-tony-lindgren-email-name.patch
maintainers-change-atm-mailing-list-to-moderated.patch
maintainers-use-tab-not-spaces-after-field-types.patch
maintainers-update-kernel-janitors-after-mismerge.patch
maintainers-update-score-architecture-name-style-and-add-file-pattern.p=
atch
maintainers-simple-firmware-interface-update-email-style.patch
maintainers-winbond-cir-integrate-p-m-lines-fixup-david-h=E4rdemans-nam=
e.patch
maintainers-fix-up-peripheral-spelling.patch
maintainers-update-wolfson-microelectronics.patch
scripts-get_maintainerpl-add-patch-file-search-for-keywords.patch
maintainers-document-new-k-entry-type.patch
maintainers-add-open-firmware-flattened-device-tree-entry.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patc=
h
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
drivers-media-video-uvc-use-%pul-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
isicomc-use-pr_fmt-and-pr_level.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
