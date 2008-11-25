From: akpm@linux-foundation.org
Subject: + pps-userland-header-file-for-pps-api.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:35:37 -0800
Message-ID: <200811252235.mAPMZb3t016342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbYKYWhL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:37:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it, alan@lxorguk.ukuu.org.uk, davej@redhat.com, dwmw2@infradead.org, greg@kroah.com, hpa@zytor.com, kay.sievers@vrfy.org, mingo@elte.hu, mtk.manpages@googlemail.com, randy.dunlap@oracle.com, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     PPS: userland header file for PPS API
has been added to the -mm tree.  Its filename is
     pps-userland-header-file-for-pps-api.patch

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
Subject: PPS: userland header file for PPS API
From: Rodolfo Giometti <giometti@linux.it>

This patch adds into the PPS's documentation directory a possible
implementation of the PPS API (RFC 2783) by using the LinuxPPS's char
devices.

This file is not just an example but it can be used into real systems.  :)

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/pps/timepps.h |  195 ++++++++++++++++++++++++++++++++++
 1 file changed, 195 insertions(+)

diff -puN /dev/null Documentation/pps/timepps.h
--- /dev/null
+++ a/Documentation/pps/timepps.h
@@ -0,0 +1,195 @@
+/*
+ * timepps.h -- PPS API main header
+ *
+ * Copyright (C) 2005-2007   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _SYS_TIMEPPS_H_
+#define _SYS_TIMEPPS_H_
+
+#include <sys/syscall.h>
+#include <unistd.h>
+#include <errno.h>
+#include <linux/pps.h>
+
+#define LINUXPPS	1		/* signal we are using LinuxPPS */
+
+/*
+ * New data structures
+ */
+
+struct ntp_fp {
+	unsigned int integral;
+	unsigned int fractional;
+};
+
+union pps_timeu {
+	struct timespec tspec;
+	struct ntp_fp ntpfp;
+	unsigned long longpad[3];
+};
+
+struct pps_info {
+	unsigned long assert_sequence;	/* seq. num. of assert event */
+	unsigned long clear_sequence;	/* seq. num. of clear event */
+	union pps_timeu assert_tu;	/* time of assert event */
+	union pps_timeu clear_tu;	/* time of clear event */
+	int current_mode;		/* current mode bits */
+};
+
+struct pps_params {
+	int api_version;		/* API version # */
+	int mode;			/* mode bits */
+	union pps_timeu assert_off_tu;	/* offset compensation for assert */
+	union pps_timeu clear_off_tu;	/* offset compensation for clear */
+};
+
+typedef int pps_handle_t;		/* represents a PPS source */
+typedef unsigned long pps_seq_t;	/* sequence number */
+typedef struct ntp_fp ntp_fp_t;		/* NTP-compatible time stamp */
+typedef union pps_timeu pps_timeu_t;	/* generic data type for time stamps */
+typedef struct pps_info pps_info_t;
+typedef struct pps_params pps_params_t;
+
+#define assert_timestamp        assert_tu.tspec
+#define clear_timestamp         clear_tu.tspec
+
+#define assert_timestamp_ntpfp  assert_tu.ntpfp
+#define clear_timestamp_ntpfp   clear_tu.ntpfp
+
+#define assert_offset		assert_off_tu.tspec
+#define clear_offset		clear_off_tu.tspec
+
+#define assert_offset_ntpfp     assert_off_tu.ntpfp
+#define clear_offset_ntpfp      clear_off_tu.ntpfp
+
+/*
+ * The PPS API
+ */
+
+static __inline int time_pps_create(int source, pps_handle_t *handle)
+{
+	int ret;
+
+	if (!handle) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	/* First we check if current device is a PPS valid PPS one...
+	 */
+	ret = ioctl(source, PPS_CHECK);
+	if (ret) {
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	/* ... then since in LinuxPPS there are no differences between a
+	 * "PPS source" and a "PPS handle", we simply return the same value.
+	 */
+	*handle = source;
+
+	return 0;
+}
+
+static __inline int time_pps_destroy(pps_handle_t handle)
+{
+	return close(handle);
+}
+
+static __inline int time_pps_getparams(pps_handle_t handle,
+					pps_params_t *ppsparams)
+{
+	int ret;
+	struct pps_kparams __ppsparams;
+
+	ret = ioctl(handle, PPS_GETPARAMS, &__ppsparams);
+
+	ppsparams->api_version = __ppsparams.api_version;
+	ppsparams->mode = __ppsparams.mode;
+	ppsparams->assert_off_tu.tspec.tv_sec = __ppsparams.assert_off_tu.sec;
+	ppsparams->assert_off_tu.tspec.tv_nsec = __ppsparams.assert_off_tu.nsec;
+	ppsparams->clear_off_tu.tspec.tv_sec = __ppsparams.clear_off_tu.sec;
+	ppsparams->clear_off_tu.tspec.tv_nsec = __ppsparams.clear_off_tu.nsec;
+
+	return ret;
+}
+
+static __inline int time_pps_setparams(pps_handle_t handle,
+					const pps_params_t *ppsparams)
+{
+	struct pps_kparams __ppsparams;
+
+	__ppsparams.api_version = ppsparams->api_version;
+	__ppsparams.mode = ppsparams->mode;
+	__ppsparams.assert_off_tu.sec = ppsparams->assert_off_tu.tspec.tv_sec;
+	__ppsparams.assert_off_tu.nsec = ppsparams->assert_off_tu.tspec.tv_nsec;
+	__ppsparams.clear_off_tu.sec = ppsparams->clear_off_tu.tspec.tv_sec;
+	__ppsparams.clear_off_tu.nsec = ppsparams->clear_off_tu.tspec.tv_nsec;
+
+	return ioctl(handle, PPS_SETPARAMS, &__ppsparams);
+}
+
+/* Get capabilities for handle */
+static __inline int time_pps_getcap(pps_handle_t handle, int *mode)
+{
+	return ioctl(handle, PPS_GETCAP, mode);
+}
+
+static __inline int time_pps_fetch(pps_handle_t handle, const int tsformat,
+					pps_info_t *ppsinfobuf,
+					const struct timespec *timeout)
+{
+	struct pps_fdata __fdata;
+	int ret;
+
+	/* Sanity checks */
+	if (tsformat != PPS_TSFMT_TSPEC) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	if (timeout) {
+		__fdata.timeout.sec = timeout->tv_sec;
+		__fdata.timeout.nsec = timeout->tv_nsec;
+		__fdata.timeout.flags = ~PPS_TIME_INVALID;
+	} else
+		__fdata.timeout.flags = PPS_TIME_INVALID;
+
+	ret = ioctl(handle, PPS_FETCH, &__fdata);
+
+	ppsinfobuf->assert_sequence = __fdata.info.assert_sequence;
+	ppsinfobuf->clear_sequence = __fdata.info.clear_sequence;
+	ppsinfobuf->assert_tu.tspec.tv_sec = __fdata.info.assert_tu.sec;
+	ppsinfobuf->assert_tu.tspec.tv_nsec = __fdata.info.assert_tu.nsec;
+	ppsinfobuf->clear_tu.tspec.tv_sec = __fdata.info.clear_tu.sec;
+	ppsinfobuf->clear_tu.tspec.tv_nsec = __fdata.info.clear_tu.nsec;
+	ppsinfobuf->current_mode = __fdata.info.current_mode;
+
+	return ret;
+}
+
+static __inline int time_pps_kcbind(pps_handle_t handle,
+					const int kernel_consumer,
+					const int edge, const int tsformat)
+{
+	/* LinuxPPS doesn't implement kernel consumer feature */
+	errno = EOPNOTSUPP;
+	return -1;
+}
+
+#endif				/* _SYS_TIMEPPS_H_ */
_

Patches currently in -mm which might be from giometti@linux.it are

linux-next.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch

