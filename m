Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013082.outbound.protection.outlook.com [52.103.43.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5466B21CFEF;
	Mon, 13 Apr 2026 22:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776119675; cv=fail; b=kqS+Qs6maJDkLEV3937KLCmEdRatlQSQOSuxMq0r0W45u+cb3CT7MRtJvnXtcUh4FM31e6+5FvsZ3AyUoFZmFJW8GKw2fB3sHgigMN8p9wCdqmTB3/hlY5UpiRq/Jp+yTwtf9loRhAPVLHt8S6wsK16pxuht8Q/oI852Oo5coO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776119675; c=relaxed/simple;
	bh=Auz2Bv3tUWe8CGD1Q3HLIXYM2YsDza7FoQRMwKJGqAA=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mWqLxJqoIsJ5nSMjmzho9CaW8SIM5pNS4J5ItrD2+MuyKMmScRQG1ahfRxRS60R+8wux+germL1lYjo/ic29qzdDatOwdR7UbgDEye+9EgHaCbBV6pqoIBd6B+N2UtTEyPpZPOvIM13ADnFg0uoAwEoBPUprjay/nyXqFLbQgrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=rLCOEEz/; arc=fail smtp.client-ip=52.103.43.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="rLCOEEz/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KscBWUq9cmxb0/Dg73usDKeWUp19oXpCPluXHwTKPBBhGhpIjkJpnNspe7eJopVdBou9XSe2nvNJ0PVyBdBGZ9sfQGYFIugfmxcrjex34LehjrfsEUNr3o8/2HNgKSHzqgP4b3+F8j0yjQnW5EsGvqdgOscOJd7mIXItGMgEUGT3ufkB2W6/m8VxnDw14LtNPzeWQnkB+edvfYnhqCj1kibuMXMBR1Y/nuS4WYgCermI8fDsXK4Dv7PLawtoEHLkC06vSpRCenaPYc2xLwCHxSYqEri85mpkvuRwJ+knA+D9OAHChPFr86ln46j+EVJ2AM/LjrCfReU3Ac5PgGz1DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bu5IGs7wRnSn9/2QKnSWtxrcmCwv57+sW2PHMNq5y+w=;
 b=xXV4C5uX6WpI/eJRnhKoY+t6jf2ur44Vd1DEFq4bwa0uKf6niZdjIElIBCG1M17aCG6xZsb6jXVLYq7JKXIAmusNQbHcxoRKSnUuJsoCsOGgxikKhpFJRxyyJa5JzlucXsvPoRFTc9NW3Kp5jajgsEkeE11jXuqlpbqSjK0lErabh6Hf2fmAXlAZhDHAfRQR6ljy9l6r/F2LIglXCRbPMEd9xXXjYVaWbVUP9zq4/NKNupJbdYQecwoQQpqp5aFUWhQOLwA7VsfUhiO/F02/jdJ//Y/cI7t4mhD10+Alp4dTQZaVrAJk9jeuI7UKNd8yFTnrVOqy4mTDg0/q7+Q+MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bu5IGs7wRnSn9/2QKnSWtxrcmCwv57+sW2PHMNq5y+w=;
 b=rLCOEEz/ru52bpE06mVDyYzqPhGrzJDY+mL1PebFQsurX9lTT7aFTEsr9ZBLQJBEL8qeF+xMdGLosGQUeieFhQWAakjdYZAhDkgKnzeFxRZFYvfgYoKte8QG6B3Dtn3KnOc+ghXOY6zX7/TPzgIDhrmEGOMgUwDGDeadJPwdviL9S0/Kh1GdousrVIAhCMTANjzDpHW2Eb4t53SJbU3ThmiVEgtanL0fCKkUlKZAo7xsQ8QNo9idil0PYxP6M0+xS0g46VMIqcG8wV3SWt/0mhRFESbmsaueWVaEfpd7F+4yc3G2DSBe1nihYZnzrKRJbw/LpKNrZxRNFfrwkQD8rA==
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com (2603:1096:990:3f::11)
 by SEZPR06MB7347.apcprd06.prod.outlook.com (2603:1096:101:253::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 22:34:29 +0000
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad]) by JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad%5]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 22:34:29 +0000
From: tejas bharambe <tejas.bharambe@outlook.com>
To: Andrew Morton <akpm@linux-foundation.org>, "mm-commits@vger.kernel.org"
	<mm-commits@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "piaojun@huawei.com" <piaojun@huawei.com>,
	"mark@fasheh.com" <mark@fasheh.com>, "junxiao.bi@oracle.com"
	<junxiao.bi@oracle.com>, "joseph.qi@linux.alibaba.com"
	<joseph.qi@linux.alibaba.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>,
	"heming.zhao@suse.com" <heming.zhao@suse.com>, "gechangwei@live.cn"
	<gechangwei@live.cn>
Subject: Re: [to-be-updated]
 ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault_retry.patch removed
 from -mm tree
Thread-Topic: [to-be-updated]
 ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault_retry.patch removed
 from -mm tree
Thread-Index: AQHcyet7Yd8e3xY7KE6hZCIphwAYMrXdl3DG
Date: Mon, 13 Apr 2026 22:34:28 +0000
Message-ID:
 <JH0PR06MB66327896972223B31B527A1089242@JH0PR06MB6632.apcprd06.prod.outlook.com>
References: <20260411194328.0CEB1C2BCAF@smtp.kernel.org>
In-Reply-To: <20260411194328.0CEB1C2BCAF@smtp.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: JH0PR06MB6632:EE_|SEZPR06MB7347:EE_
x-ms-office365-filtering-correlation-id: def58568-515d-48b6-5da8-08de99acd308
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|8060799015|15030799006|41001999006|461199028|8062599012|31061999003|19110799012|25031999004|37011999003|10035399007|440099028|4302099013|3412199025|12091999003|26121999003|102099032|11031999003|1602099012|40105399003|52005399003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?iggbNfUJSWf44hboUFJ70bmhhQwECKIokhMv6Hm/8sMFziwH+u6j6Yu6jE?=
 =?iso-8859-1?Q?ADux7fV95v5xzIcvcQ7S3tAtVmrOTD+3s1rh9BSRCF0lYy196dmMa5CBnc?=
 =?iso-8859-1?Q?+oT3KOvEL015t+rJYfN+yuKrlnf2UWT1kGOxBs9V0M8IWMyROPRDRdscxM?=
 =?iso-8859-1?Q?Dbwi4U97KOyrAbnSJgGLVtaRv2+DxeWgjYWzOYFEjkI2zKeBcRLLi4Bgc4?=
 =?iso-8859-1?Q?vVtk3rJ1KmcAGtO00Gef24u0A40T60sI1BdF3Mg5dR3F+0kuuftHqZ2lH3?=
 =?iso-8859-1?Q?ImVpjq1jjW1moYpkn+rRRZTq53lF1BCyHycqg6JCuYTlj5lBsZTZWMwlPa?=
 =?iso-8859-1?Q?IHwkrInDRW4At6FsurgZOTfhkJhmaXQu9doelX/LY87eC8LUNmFiEFxtkE?=
 =?iso-8859-1?Q?rDcg+a2hNuNzSjay08XU/qthJ5cX5hQ/XmwdxpGLzVhFjRUHlv8lt+z8tx?=
 =?iso-8859-1?Q?rGJkE1s55WBYpgUGLXgyGBNhI3D3PbEtL9q7dnUmOpjVQ1LnRU5yx8J8zM?=
 =?iso-8859-1?Q?Rv/HbVzjYdB24VpY3eS5fK+uUGsvtqP3JBd54GhUZvfGEJ7jItEWaBMhGN?=
 =?iso-8859-1?Q?/uZtn2zLV8ojVfxx2MO3BmgfVBR6IsT7wwK4dU4ldtgYMV92riwnBlK38P?=
 =?iso-8859-1?Q?b/vQi8c9er/urY0iqofW2sU5bbz9nH5ui4N3Yy9f8mrKH+5U9zZYFXJW2A?=
 =?iso-8859-1?Q?6Dejw6Lgkegvb6GdBL2EI/95z0ZZMaDzcFF1ALKpgxgTxvY0YkQqfYmUf1?=
 =?iso-8859-1?Q?tYROzbWEfhnYSpjXZcBriaUFM4zs1TPNkKtUXw+EwClDdI/PopnJYpqzNU?=
 =?iso-8859-1?Q?i3s0pi7n6cmZS+gdhBJRa/eN8M7zLVgm41AbWnuGUjDZN6vzUGkbayJdTl?=
 =?iso-8859-1?Q?PTW3VqqwGAqH9B5LxwWt5QaCIUQTBFcdEGonslRofpV+dW5ZqJyHFtKngb?=
 =?iso-8859-1?Q?ITb3jsGVp8vtEG1HYUrT9znnuUf9VfY14kmkELyoeyPT4C3ijnanxAqWlx?=
 =?iso-8859-1?Q?JW3o2XIgr0E2GB3+n3Z9FzRYML7QAEIZ/moJ5umU0aq5DDSuqV8ksCvhYr?=
 =?iso-8859-1?Q?3YZqoLVLyqUexedtnsseKoaTLo3ulaF0pnIXcKuTFQB/4PAdFe1/hvI1/0?=
 =?iso-8859-1?Q?bX5zHRl10hF1tsYyUFyRxmc132jU3aEsqD4N/qo8dPAN9KS6eaUvZshkS4?=
 =?iso-8859-1?Q?9SCEeJCTh9z2ZjC2vX43OlHFS1/nj8pQ6khtITrhf4ul3MXOqir9RJKCel?=
 =?iso-8859-1?Q?w7oMHF7Lt+Pdz+e/CttA=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?E1cIHw3z18Y8+5KS5VAN+P5Ld9Fe/E4+VUVrGruYTWU97hyAcYKqiKYq3t?=
 =?iso-8859-1?Q?OOcvNrXVXEphgO4v1mGPizRKCSdXOPYpCxFPmDniSxqDdpOvud0vEW9w2Z?=
 =?iso-8859-1?Q?utk6bCzPx5IyZH2JZLmnFqK3pJJsQ3I+w2LjYsRC5rPDQEynnQHhBoiPmo?=
 =?iso-8859-1?Q?GTk1Cykq7r8UQfqgDC+7QP97S/ye7YdMcOofIZZHTqoLjvZESjL0ewHo0s?=
 =?iso-8859-1?Q?Go9h5LNpzUqG2GLIfH4j/4p3Dk6Nz4ngWksb+2Jd21uExOKPiJROSkcB/b?=
 =?iso-8859-1?Q?aRWyXM1UQ9TzVcJvr/EwC6nZwIx3KwZVU4z2eqIfkdGIZHsS816gHs77AR?=
 =?iso-8859-1?Q?syJ1jmPHrNqTk7qLZ2bGCNVcMtanTJWXRDbBrJ0KdDPUl2/xsBPPEzWY6x?=
 =?iso-8859-1?Q?kKlVt+3QdrYGPaSfXIv5W2sLs2XYNWFo0114sytDzNkY0nhoXWTVS3kSmG?=
 =?iso-8859-1?Q?h10iHBpyaELcENgMipRgymKYLVE3FNI0176E91mU+4gXeI7k8AF1g1IXS/?=
 =?iso-8859-1?Q?NnOhqGJLf2O17X1B/eAXhyX5Gh12Wv47BwQdx1Kec+5wfTl9joumeUibyU?=
 =?iso-8859-1?Q?FDDu4ZTzX5KDM1xLNtp6RRihAbaQut5pwHgRQdpSInyre6ZVJXe4ypUECK?=
 =?iso-8859-1?Q?1133DWBeS5QRPwfx21bC8VCFfSvDjLQZSmYUz2fHfJsUGnalFtETaOY2Dg?=
 =?iso-8859-1?Q?YcZIxypC7ObG68bSDmSmxi8fyb3NB0aE2dqAOPkxW4potbaZ3jsoho7Fds?=
 =?iso-8859-1?Q?33jCsxc4vBNHIll0CzDGVVcZHoaeRvOevSaO5YMm8BaxejbOiJjAcC5RFz?=
 =?iso-8859-1?Q?/Py0jdZAyhdLBYhToFg7Z9r1EGXiHQZZtywQpuUDAjSARm6YcFriCLmABK?=
 =?iso-8859-1?Q?FSQ9Pm30+CBVVx64/HVhKSeYPd34Z1XlHxEYV3sddtl2ieqwAkkxF6Tw+i?=
 =?iso-8859-1?Q?DOLeAZEKJ4Oenspyu94/cGngss0pyFzl0y5THycXo90oHk9JsAqsPFMXzH?=
 =?iso-8859-1?Q?hO6B57zVOY+QLLb32OpIBp0OsbtkasO7Eu2B1+J82B4/TgOzBnYBtrq9P/?=
 =?iso-8859-1?Q?oV79C6PovrZ7SOp47SzBHd2iz32M/XTszki+D6cvGVM2YNONkKTuKKtw1N?=
 =?iso-8859-1?Q?nVSs852JLm/broyWa6t/C+exC4ABPKcOWItQviqvu2P69IjU7vfUm0diGa?=
 =?iso-8859-1?Q?wK/lF0DTcBabKsBnfWxC+hOpEJeQDG/F+Wmuf9UGG4+rxr8vNwfquVIpuC?=
 =?iso-8859-1?Q?s4F9WjXhovyaamVuO+oKjeuERZD2ir2jF3LR47UOaGk/aEceMnXPBE6A4w?=
 =?iso-8859-1?Q?R2CJ2lAtbEm65Lse2PCw1wVGUkS+SXrs9HyTkG8TzUQS4+bmYMcdTarvn7?=
 =?iso-8859-1?Q?qipIFKX7aN+c81OrHNlJhHQPWGxcbaal4VBWx4FzUwIUKQSEN5M9Au3vmG?=
 =?iso-8859-1?Q?fTfuWay4Nj485Pkz?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: JH0PR06MB6632.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: def58568-515d-48b6-5da8-08de99acd308
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2026 22:34:28.5970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB7347

Hi Andrew,

Any action item on my end?



________________________________________
From: Andrew Morton <akpm@linux-foundation.org>
Sent: Saturday, April 11, 2026 12:43 PM
To: mm-commits@vger.kernel.org <mm-commits@vger.kernel.org>; stable@vger.ke=
rnel.org <stable@vger.kernel.org>; piaojun@huawei.com <piaojun@huawei.com>;=
 mark@fasheh.com <mark@fasheh.com>; junxiao.bi@oracle.com <junxiao.bi@oracl=
e.com>; joseph.qi@linux.alibaba.com <joseph.qi@linux.alibaba.com>; jlbec@ev=
ilplan.org <jlbec@evilplan.org>; heming.zhao@suse.com <heming.zhao@suse.com=
>; gechangwei@live.cn <gechangwei@live.cn>; tejas.bharambe@outlook.com <tej=
as.bharambe@outlook.com>; akpm@linux-foundation.org <akpm@linux-foundation.=
org>
Subject: [to-be-updated] ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fa=
ult_retry.patch removed from -mm tree


The quilt patch titled
     Subject: ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETR=
Y
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault_retry.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Tejas Bharambe <tejas.bharambe@outlook.com>
Subject: ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
Date: Wed, 1 Apr 2026 21:02:34 -0700

filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,
as documented in mm/filemap.c:

  "If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
  may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."

When this happens, a concurrent munmap() can call remove_vma() and free
the vm_area_struct via RCU. The saved 'vma' pointer in ocfs2_fault() then
becomes a dangling pointer, and the subsequent trace_ocfs2_fault() call
dereferences it -- a use-after-free.

Fix this by saving the inode reference before calling filemap_fault(),
and removing vma from the trace event. The inode remains valid across
the lock drop since the file is still open, so the trace can fire in
all cases without dereferencing the potentially freed vma.

Link: https://lkml.kernel.org/r/20260403035333.136824-1-tejas.bharambe@outl=
ook.com
Link: https://lkml.kernel.org/r/20260402040234.92432-1-tejas.bharambe@outlo=
ok.com
Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3Da49010a0e8fcdeea075f
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/mmap.c        |    6 +++---
 fs/ocfs2/ocfs2_trace.h |   10 ++++------
 2 files changed, 7 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/mmap.c~ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault=
_retry
+++ a/fs/ocfs2/mmap.c
@@ -30,7 +30,7 @@

 static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
 {
-       struct vm_area_struct *vma =3D vmf->vma;
+       struct inode *inode =3D file_inode(vmf->vma->vm_file);
         sigset_t oldset;
         vm_fault_t ret;

@@ -38,8 +38,8 @@ static vm_fault_t ocfs2_fault(struct vm_
         ret =3D filemap_fault(vmf);
         ocfs2_unblock_signals(&oldset);

-       trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,
-                         vma, vmf->page, vmf->pgoff);
+       trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno,
+                         vmf->page, vmf->pgoff);
         return ret;
 }

--- a/fs/ocfs2/ocfs2_trace.h~ocfs2-fix-use-after-free-in-ocfs2_fault-when-v=
m_fault_retry
+++ a/fs/ocfs2/ocfs2_trace.h
@@ -1246,22 +1246,20 @@ TRACE_EVENT(ocfs2_write_end_inline,

 TRACE_EVENT(ocfs2_fault,
         TP_PROTO(unsigned long long ino,
-                void *area, void *page, unsigned long pgoff),
-       TP_ARGS(ino, area, page, pgoff),
+                void *page, unsigned long pgoff),
+       TP_ARGS(ino, page, pgoff),
         TP_STRUCT__entry(
                 __field(unsigned long long, ino)
-               __field(void *, area)
                 __field(void *, page)
                 __field(unsigned long, pgoff)
         ),
         TP_fast_assign(
                 __entry->ino =3D ino;
-               __entry->area =3D area;
                 __entry->page =3D page;
                 __entry->pgoff =3D pgoff;
         ),
-       TP_printk("%llu %p %p %lu",
-                 __entry->ino, __entry->area, __entry->page, __entry->pgof=
f)
+       TP_printk("%llu %p %lu",
+                 __entry->ino, __entry->page, __entry->pgoff)
 );

 /* End of trace events for fs/ocfs2/mmap.c. */
_

Patches currently in -mm which might be from tejas.bharambe@outlook.com are

