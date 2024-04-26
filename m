Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9860B13A3E7
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 08:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714118999; cv=none; b=NX6qF4c+yW70LHf+eouWSj9IE0wAVtjEFLTZfVnU4gR+D5/IlLo4frjs9rQsd6DjDJfc9/vR8LtcC/QykHCPCQyxX8UbDjofQeYGWS6HT206a43gAXteicSo045CKgFaws1d4igKyjnuFJ/LWbiUF0rda3xEmFMnzwpp3I6z/fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714118999; c=relaxed/simple;
	bh=14yysJVO49Eydv+sQUop99FX++/CfWr8j2XkR++gEgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fPuXOrg9UQLlqD6sXBMXR5wIRyRhhlMOKI7t12SP7jyZGd2eLtb+ME8sou5EDbAkZq+jRGjhdv6/6DmX1AjujZry0sCT8eimelLjvg9mRvM4x2ePZX2s5vRbF1tElzHsld/FwxdKXxxRFp87fm04y6j4/h4CYVjG7SPqUiUHqSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pL3J3Mzl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pL3J3Mzl"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43Q7oQqL009563;
	Fri, 26 Apr 2024 08:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=KKrW8zIuiNoVNCN4CEiYsK0pFT2mYbX4+tNse/xiL4k=;
 b=pL3J3MzlZKWmcA1iV1B34CkKWYUUwQ3SZPsUbQCuCA5E/qOWlgJZbUR4FIQ6uMFMp5cP
 wM1zZa97VaoHGndCzPFSb5bc0IYXarH/QphqZagKUEMRDF6IF03zebsPmwQiWCGE59rV
 /EL19uOTK1yoj8Nx2KdPN5PwYxkJmIfKmQ46XKynHDF3nCekCJQ5gCpbjqB3JEAAyB6X
 DQQKJc1t4kuPHhP+qHWG4ve4k1L9kdmiC7/ky8rhfWMNQ+wp8NQoVCbmaaKoCQGrVF7M
 ytOelGq3Z2bUG1Q3w1YyoX6c2xZmvUV0G9RRHO3rB2iCjOBSzJXVJ1PRfmXW/Si667Uk 5g== 
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xr86m81np-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Apr 2024 08:09:48 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43Q6VjK4005384;
	Fri, 26 Apr 2024 08:09:47 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmx3cwcjg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Apr 2024 08:09:47 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43Q89fNO30409336
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Apr 2024 08:09:43 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6B472004B;
	Fri, 26 Apr 2024 08:09:41 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C7FD20040;
	Fri, 26 Apr 2024 08:09:41 +0000 (GMT)
Received: from osiris (unknown [9.171.34.163])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 26 Apr 2024 08:09:41 +0000 (GMT)
Date: Fri, 26 Apr 2024 10:09:39 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, wintera@linux.ibm.com, twinkler@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com,
        arnd@arndb.de, agordeev@linux.ibm.com, nathan@kernel.org
Subject: Re: [merged mm-nonmm-stable]
 s390-smsgiucv_app-remove-function-pointer-cast.patch removed from -mm tree
Message-ID: <20240426080939.8950-B-hca@linux.ibm.com>
References: <20240426040812.EA47DC113CD@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240426040812.EA47DC113CD@smtp.kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NvYzMQ4oAUZsg-jYkHRyuHUE7zhqB9OS
X-Proofpoint-ORIG-GUID: NvYzMQ4oAUZsg-jYkHRyuHUE7zhqB9OS
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 mlxscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404260051

On Thu, Apr 25, 2024 at 09:08:12PM -0700, Andrew Morton wrote:
> The quilt patch titled
>      Subject: s390/smsgiucv_app: remove function pointer cast
> has been removed from the -mm tree.  Its filename was
>      s390-smsgiucv_app-remove-function-pointer-cast.patch
> 
> This patch was dropped because it was merged into the mm-nonmm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: Nathan Chancellor <nathan@kernel.org>
> Subject: s390/smsgiucv_app: remove function pointer cast
> Date: Wed, 17 Apr 2024 11:24:36 -0700
> 
> Clang warns (or errors with CONFIG_WERROR) after enabling
> -Wcast-function-type-strict by default:
> 
>   drivers/s390/net/smsgiucv_app.c:176:26: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
>     176 |         smsg_app_dev->release = (void (*)(struct device *)) kfree;
>         |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> Add a standalone function to fix the warning properly, which addresses
> the root of the warning that these casts are not safe for kCFI.
> 
> Link: https://lkml.kernel.org/r/20240417-s390-drivers-fix-cast-function-type-v1-2-fd048c9903b0@kernel.org
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
> 
>  drivers/s390/net/smsgiucv_app.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Same here, please drop this patch.
