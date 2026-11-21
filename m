Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795296527;
	b=Asxdzh0myoLr0ArhNvlllcOnwsmXhUF4tKOA1vwW4I7R++bxGX1DyWbGj+LPBGudOgfj
	 +BlCz41ki/gOv/G0XeYlQsXGADXhyAAfeQLFvv0IsxZO7dqZuxgfMFp/gyNRX/rLSO5zg
	 cuZ5Hz63w4D+ub3eTFXirqoxtnwvlxamD3jgD04yWSc/dmRK0NK8dyBxm1aOGiEW3qMre
	 Bx5hC5VleQz5IIqtqQs0gHA01knscn6wm+lJB23ummG0/w2QeWtzbLzi8cFvqXVI1pw/4
	 FP+7GAZQywsf8sGxGMh+Az7md870O+v+xG7VTVXLYQs58mz9utzrZMD2A/HX00/GoSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795296527;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=2ANdwTkgFnCLX2uiC/ZRicSZlvifAWnMnZbQZwNu3GQ=;
	b=p8byNWgVL63lTBqUK+1av5unNiANjgYKcNPYmWW5oAlCmyylhXQJo5QX7gWSp7m90hWi
	 nnpeKHFjBIuuvv0FX0XgfrsPxdRC/CHEEfndEh0y5KHM8kD82eL3OgJrnYY/KUCYs9rzU
	 WchKLSmmDMuE5H0wcnun/NkXDNv3AcDUx4ewn7nfyh71tH5e8qDMHsXPFZdqhrTNFsuP7
	 aXM21+ay8flJkRy6nZOt5XdecFB87RUU1x2qRIBM4QJGCRTqFWVynnq1CVUVYMatn/96w
	 fHkMTd1+TyIUT+XH51U0mdManVBESUHOF5JZWLUeRZ+rEJ0NQASGC44OxtjC/1jfGAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L5qY7ndM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9F1606A320;
	Sat, 21 Nov 2026 21:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L5qY7ndM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F101B1F000C4;
	Sat, 21 Nov 2026 21:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795296527;
	bh=2ANdwTkgFnCLX2uiC/ZRicSZlvifAWnMnZbQZwNu3GQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=L5qY7ndM941SMfKhZJKKInr2YlOLDyyKt2hPYrjVxfKnmtHlsJelqzZdr114up8u/
	 FtpgpB0bh+C1cJopFYK/hhGxdcWhPgzIXsy9+wASJMQVC6pCVThrnpNbn70apnlPjY
	 WyppVYGKS/Z6yEir+T5Vyu7xiXPhdDOTI+Cl/fUw=
Date: Sat, 21 Nov 2026 13:28:46 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,
	shubhang@os.amperecomputing.com,shuaibinglu@126.com,shuah@kernel.org,
	sh@gentwo.org,manfred@colorfullife.com,jan.koester@tuxist.de,
	dave@stgolabs.net,cl@gentwo.org,teel4res@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <179328314077.648427.7284615104475689945@gmail.com>
References: <179328314077.648427.7284615104475689945@gmail.com>
Subject: + ipc-msg-align-compat-version-0-msqid_ds-with-native-ipc_old.patch added to mm-nonmm-unstable branch
Message-Id: <20261121212846.F101B1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ipc/msg: align compat version-0 msqid_ds with native IPC_OLD
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-msg-align-compat-version-0-msqid_ds-with-native-ipc_old.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-msg-align-compat-version-0-msqid_ds-with-native-ipc_old.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Cheng Yongkang <teel4res@gmail.com>
Subject: ipc/msg: align compat version-0 msqid_ds with native IPC_OLD
Date: Thu, 29 Oct 2026 07:12:20 -0700

The compat version-0 IPC_STAT path copies the 64-bit counters into the
16-bit msg_cbytes/msg_qnum/msg_qbytes fields without clamping, and leaves
msg_lcbytes/msg_lqbytes zero.  A queue with 65536 bytes, 8 messages and
q_qbytes=200000 is reported as cbytes=0, qnum=8, qbytes=3392,
lcbytes=lqbytes=0, while the native IPC_OLD path reports the clamped
counters and the full values in the l fields.

The compat version-0 IPC_SET path reads only the 16-bit msg_qbytes and
ignores msg_lqbytes.  A caller following the old ABI with msg_qbytes=0 and
msg_lqbytes=131072 gets q_qbytes=0 and the queue stops accepting messages,
while the native IPC_OLD path falls back to msg_lqbytes.

Mirror the native IPC_OLD handling in both compat version-0 branches:
clamp the counters to USHRT_MAX and fill the l fields on stat, and fall
back to msg_lqbytes when the 16-bit qbytes is zero on set.  The compat
IPC_64 branches and the native paths are unchanged.

Link: https://patch.msgid.link/179328314077.648427.7284615104475689945@gmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christopher Lameter (Ampere) <cl@gentwo.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jan Koester <jan.koester@tuxist.de>
Cc: Lu Shuaibing <shuaibinglu@126.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
Cc: Shubhang Kaushik <shubhang@os.amperecomputing.com>
Cc: <stable@vger.kernel.org>

 ipc/msg.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/ipc/msg.c~ipc-msg-align-compat-version-0-msqid_ds-with-native-ipc_old
+++ a/ipc/msg.c
@@ -687,10 +687,17 @@ static int copy_compat_msqid_from_user(s
 			return -EFAULT;
 	} else {
 		struct compat_msqid_ds __user *p = buf;
+		compat_ulong_t qbytes;
+
 		if (get_compat_ipc_perm(&out->msg_perm, &p->msg_perm))
 			return -EFAULT;
-		if (get_user(out->msg_qbytes, &p->msg_qbytes))
+		if (get_user(qbytes, &p->msg_qbytes))
 			return -EFAULT;
+		if (qbytes == 0) {
+			if (get_user(qbytes, &p->msg_lqbytes))
+				return -EFAULT;
+		}
+		out->msg_qbytes = qbytes;
 	}
 	return 0;
 }
@@ -721,9 +728,23 @@ static int copy_compat_msqid_to_user(voi
 		v.msg_stime = in->msg_stime;
 		v.msg_rtime = in->msg_rtime;
 		v.msg_ctime = in->msg_ctime;
-		v.msg_cbytes = in->msg_cbytes;
-		v.msg_qnum = in->msg_qnum;
-		v.msg_qbytes = in->msg_qbytes;
+		if (in->msg_cbytes > USHRT_MAX)
+			v.msg_cbytes = USHRT_MAX;
+		else
+			v.msg_cbytes = in->msg_cbytes;
+		v.msg_lcbytes = in->msg_cbytes;
+
+		if (in->msg_qnum > USHRT_MAX)
+			v.msg_qnum = USHRT_MAX;
+		else
+			v.msg_qnum = in->msg_qnum;
+
+		if (in->msg_qbytes > USHRT_MAX)
+			v.msg_qbytes = USHRT_MAX;
+		else
+			v.msg_qbytes = in->msg_qbytes;
+		v.msg_lqbytes = in->msg_qbytes;
+
 		v.msg_lspid = in->msg_lspid;
 		v.msg_lrpid = in->msg_lrpid;
 		return copy_to_user(buf, &v, sizeof(v));
_

Patches currently in -mm which might be from teel4res@gmail.com are

ipc-msg-align-compat-version-0-msqid_ds-with-native-ipc_old.patch

