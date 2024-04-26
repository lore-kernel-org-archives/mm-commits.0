Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDC913A3E7
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 08:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714118975; cv=none; b=sffAzsceSCzhl6bNy7BE4mFoYyBT8/VIskx1erXrlw08ZgVcKkePAO2GDcy1JHJ9P64p1NKB8X46zPL7N0uF1wzHRpXdH6aBe711tK9NycUjbA/cVSXrQucDFbtWnUaZ3ZELKeHQAYeCofa2YdAW8WLthF1P2+el7lwVW0APlfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714118975; c=relaxed/simple;
	bh=WczpTDg7z+WPPXmFJmMg4Z08RpW9wnCwiBecer+ep54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m3SbFcxQMRwmqlX2Oln4kafAmLo0wWG0O4ohUKNJ1b1pA1EjT83VGtEcp8Nrd1M1FVOlG7HgZTUQd91pG+GrzK9mg0RXe/SlaqPCWvHbAOUSQGVQV2lbbHmhRsNhLFCGW1O6gPZI40gyh39Yz4wz2tkFrEzLvRsrGA67nvGSbXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ae5Lgf4G; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ae5Lgf4G"
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43Q82RW6026951;
	Fri, 26 Apr 2024 08:09:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=ym9W1mKX1VkL286rbfwJ5modb1r8DeEVWfnlvBp8D0o=;
 b=ae5Lgf4GjPI9AoXuQLwgJ3TkiHsy5+8mZ85lqCcS646MBhJInFt93+18Q6P9YuBVZnvI
 fuo8IBJZ4kE4y1o032nlbapL9v5DUvtRk0utcwcD8BTTEzsBzsps1WWz11S/Xt2ICANt
 3N4kXah7sZhBIFCwNrLSKM5oi2ttc5LvbKpFjXA1TS9JG9jLeT9fuigG9zfbUHqSm6bl
 ZPJj7GTHOoA2r9LVwUHpRvuoCUuS67YjhwP+yHdZc1RbYtNG0rjVAf6fECPVFs/lOiV1
 L3ItT8S82KFsPux9frgwvkn/vyXhVO2WV9f0QakLOG9PFavquSTAyo2jSozAP82abTwK zQ== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xr8ddg0e3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Apr 2024 08:09:24 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43Q7Ea59029863;
	Fri, 26 Apr 2024 08:09:23 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmr1txu60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Apr 2024 08:09:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43Q89Iqo9175496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Apr 2024 08:09:20 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1BF0D20040;
	Fri, 26 Apr 2024 08:09:18 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B0832005A;
	Fri, 26 Apr 2024 08:09:17 +0000 (GMT)
Received: from osiris (unknown [9.171.34.163])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 26 Apr 2024 08:09:17 +0000 (GMT)
Date: Fri, 26 Apr 2024 10:09:16 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, wintera@linux.ibm.com, twinkler@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com,
        arnd@arndb.de, agordeev@linux.ibm.com, nathan@kernel.org
Subject: Re: [merged mm-nonmm-stable]
 s390-vmlogrdr-remove-function-pointer-cast.patch removed from -mm tree
Message-ID: <20240426080916.8950-A-hca@linux.ibm.com>
References: <20240426040811.C7F2BC113CD@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240426040811.C7F2BC113CD@smtp.kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ufifvo1xqTAn4sKRGkQrsslcDcJOWMok
X-Proofpoint-ORIG-GUID: ufifvo1xqTAn4sKRGkQrsslcDcJOWMok
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-26_07,2024-04-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 spamscore=0 lowpriorityscore=0 clxscore=1011 impostorscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404260051

Hi Andrew,

> The quilt patch titled
>      Subject: s390/vmlogrdr: remove function pointer cast
> has been removed from the -mm tree.  Its filename was
>      s390-vmlogrdr-remove-function-pointer-cast.patch
> 
> This patch was dropped because it was merged into the mm-nonmm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: Nathan Chancellor <nathan@kernel.org>
> Subject: s390/vmlogrdr: remove function pointer cast
> Date: Wed, 17 Apr 2024 11:24:35 -0700
> 
> Patch series "drivers/s390: Fix instances of -Wcast-function-type-strict".
> 
> This series resolves the instances of -Wcast-function-type-strict that
> show up in my s390 builds on -next, which has this warning enabled by
> default.
> 
> 
> This patch (of 3):
> 
> Clang warns (or errors with CONFIG_WERROR) after enabling
> -Wcast-function-type-strict by default:
> 
>   drivers/s390/char/vmlogrdr.c:746:18: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
>     746 |                 dev->release = (void (*)(struct device *))kfree;
>         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> Add a standalone function to fix the warning properly, which addresses
> the root of the warning that these casts are not safe for kCFI. The
> comment is not really relevant after this change, so remove it.
> 
> Link: https://lkml.kernel.org/r/20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org
> Link: https://lkml.kernel.org/r/20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Alexandra Winter <wintera@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Thorsten Winkler <twinkler@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Per this discussion [1] this patch should be dropped. This will be
solved differently.

[1] https://lore.kernel.org/all/20240418102549.6056-B-hca@linux.ibm.com/
