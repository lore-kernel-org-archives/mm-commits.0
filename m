Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2268C27473
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727382461; cv=none; b=f4JCojSXcWYdqYrp8L582t3RHuTCi2b45crowiW+bu7Za4u6kaYfLd8fb3Hz1ib9fNU/OyDQk2WgSpV05jvuEr/n41hbIdEjTnC/l0AtTK9IufXidZSfHSE3BVyRgGj2VfP1rS6t5pHttXZC7/l6/Q2pMg9qfMMdhxErDVcRVPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727382461; c=relaxed/simple;
	bh=d3J/QspdTZDOx2ka4vnjQRKsXJMR5BZSRro7AP5iUeo=;
	h=Date:To:From:Subject:Message-Id; b=mQmafodnTJduo5HY5gPnOItgZaAW04vCGysYWTiVWYojuBXdQX3JPjZddaipvaWDiPYhuW5Uas4upmSuyQBEvk3bt5XiKbSJO7BOBP94b1D8L+xYiaaVl8+jCbyNBS7Rap+H4I1SWg1e78tW9RqK0I0hNCl2Ep0MZdJLM2z9oTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=coWd8SbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="coWd8SbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66061C4CEC5;
	Thu, 26 Sep 2024 20:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727382460;
	bh=d3J/QspdTZDOx2ka4vnjQRKsXJMR5BZSRro7AP5iUeo=;
	h=Date:To:From:Subject:From;
	b=coWd8SbJhmoIxxH1ZDFgzslWx/59lGyityqlWrMdkXu29GgaorstrzbuXybfDZtlj
	 QlPD92JbV/53lZbC10Tyfv7Yqr5W5FrWReKbJSfCn4DrpzZEOK+1Ddm5D5JY6gmXzK
	 ruTs3+DYCAzE7uJJAJxrhI/6E81o750dpuEALioY=
Date: Thu, 26 Sep 2024 13:27:39 -0700
To: mm-commits@vger.kernel.org,yanzhen@vivo.com,shenlichuan@vivo.com,jesse.brandeburg@intel.com,colin.i.king@gmail.com,yujiaoliang@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-add-more-spellings-corrections.patch added to mm-nonmm-unstable branch
Message-Id: <20240926202740.66061C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/spelling.txt: add more spellings corrections
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-spellingtxt-add-more-spellings-corrections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-spellingtxt-add-more-spellings-corrections.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yu Jiaoliang <yujiaoliang@vivo.com>
Subject: scripts/spelling.txt: add more spellings corrections
Date: Thu, 26 Sep 2024 18:16:15 +0800

Add several common typo patterns to the scripts/spelling.txt file to
ensure checkpatch.pl can detect and prevent these typos in the future.

This update helps improve code quality by preventing recurring typos.

Link: https://lkml.kernel.org/r/20240926101617.3988613-1-yujiaoliang@vivo.com
Signed-off-by: Yu Jiaoliang <yujiaoliang@vivo.com>
Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
Signed-off-by: Yan Zhen <yanzhen@vivo.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-corrections
+++ a/scripts/spelling.txt
@@ -141,6 +141,7 @@ anomoly||anomaly
 anonynous||anonymous
 anway||anyway
 aplication||application
+apeared||appeared
 appearence||appearance
 applicaion||application
 appliction||application
@@ -155,6 +156,7 @@ apropriate||appropriate
 aquainted||acquainted
 aquired||acquired
 aquisition||acquisition
+aquires||acquires
 arbitary||arbitrary
 architechture||architecture
 archtecture||architecture
@@ -185,10 +187,12 @@ assotiated||associated
 asssert||assert
 assum||assume
 assumtpion||assumption
+asume||assume
 asuming||assuming
 asycronous||asynchronous
 asychronous||asynchronous
 asynchnous||asynchronous
+asynchrnous||asynchronous
 asynchronus||asynchronous
 asynchromous||asynchronous
 asymetric||asymmetric
@@ -269,6 +273,7 @@ caculate||calculate
 caculation||calculation
 cadidate||candidate
 cahces||caches
+calcluate||calculate
 calender||calendar
 calescing||coalescing
 calibraiton||calibration
@@ -331,6 +336,7 @@ chouse||chose
 circumvernt||circumvent
 claread||cleared
 clared||cleared
+clearify||clarify
 closeing||closing
 clustred||clustered
 cnfiguration||configuration
@@ -379,12 +385,14 @@ comsumed||consumed
 comunicate||communicate
 comunication||communication
 conbination||combination
+concurent||concurrent
 conditionaly||conditionally
 conditon||condition
 condtion||condition
 condtional||conditional
 conected||connected
 conector||connector
+configed||configured
 configration||configuration
 configred||configured
 configuartion||configuration
@@ -394,6 +402,7 @@ configuratoin||configuration
 configuraton||configuration
 configuretion||configuration
 configutation||configuration
+congiuration||configuration
 conider||consider
 conjuction||conjunction
 connecetd||connected
@@ -403,6 +412,7 @@ connnection||connection
 connnections||connections
 consistancy||consistency
 consistant||consistent
+consits||consists
 containes||contains
 containts||contains
 contaisn||contains
@@ -452,6 +462,7 @@ decendants||descendants
 decompres||decompress
 decsribed||described
 decription||description
+detault||default
 dectected||detected
 defailt||default
 deferal||deferral
@@ -487,6 +498,7 @@ depreacte||deprecate
 desactivate||deactivate
 desciptor||descriptor
 desciptors||descriptors
+descritpor||descriptor
 descripto||descriptor
 descripton||description
 descrition||description
@@ -601,6 +613,7 @@ enchanced||enhanced
 encorporating||incorporating
 encrupted||encrypted
 encrypiton||encryption
+encryped||encrypted
 encryptio||encryption
 endianess||endianness
 enpoint||endpoint
@@ -630,6 +643,7 @@ etsbalishment||establishment
 evalute||evaluate
 evalutes||evaluates
 evalution||evaluation
+evaulated||evaluated
 excecutable||executable
 excceed||exceed
 exceded||exceeded
@@ -650,6 +664,7 @@ exlcude||exclude
 exlcuding||excluding
 exlcusive||exclusive
 exlusive||exclusive
+exlicitly||explicitly
 exmaple||example
 expecially||especially
 experies||expires
@@ -834,6 +849,7 @@ informations||information
 informtion||information
 infromation||information
 ingore||ignore
+inheritence||inheritance
 inital||initial
 initalized||initialized
 initalised||initialized
@@ -878,6 +894,7 @@ interoprability||interoperability
 interuupt||interrupt
 interupt||interrupt
 interupts||interrupts
+interurpt||interrupt
 interrface||interface
 interrrupt||interrupt
 interrup||interrupt
@@ -925,6 +942,7 @@ jumpimng||jumping
 juse||just
 jus||just
 kown||known
+lable||label
 langage||language
 langauage||language
 langauge||language
@@ -995,6 +1013,7 @@ metdata||metadata
 micropone||microphone
 microprocesspr||microprocessor
 migrateable||migratable
+miliseconds||milliseconds
 millenium||millennium
 milliseonds||milliseconds
 minimim||minimum
@@ -1132,6 +1151,7 @@ palne||plane
 paramameters||parameters
 paramaters||parameters
 paramater||parameter
+paramenters||parameters
 parametes||parameters
 parametised||parametrised
 paramter||parameter
@@ -1177,9 +1197,11 @@ poiter||pointer
 posible||possible
 positon||position
 possibilites||possibilities
+postion||position
 potocol||protocol
 powerfull||powerful
 pramater||parameter
+preambule||preamble
 preamle||preamble
 preample||preamble
 preapre||prepare
@@ -1269,6 +1291,7 @@ raoming||roaming
 reasearcher||researcher
 reasearchers||researchers
 reasearch||research
+recalcualte||recalculate
 receieve||receive
 recepient||recipient
 recevied||received
@@ -1291,6 +1314,7 @@ refcounf||refcount
 refence||reference
 refered||referred
 referenace||reference
+refererence||reference
 refering||referring
 refernces||references
 refernnce||reference
@@ -1315,12 +1339,14 @@ reloade||reload
 remoote||remote
 remore||remote
 removeable||removable
+repective||respective
 repectively||respectively
 replacable||replaceable
 replacments||replacements
 replys||replies
 reponse||response
 representaion||representation
+repsonse||response
 reqeust||request
 reqister||register
 requed||requeued
@@ -1444,6 +1470,7 @@ soluation||solution
 souce||source
 speach||speech
 specfic||specific
+specfication||specification
 specfield||specified
 speciefied||specified
 specifc||specific
@@ -1544,6 +1571,7 @@ syncronus||synchronous
 syste||system
 sytem||system
 sythesis||synthesis
+tagert||target
 taht||that
 tained||tainted
 tarffic||traffic
@@ -1574,6 +1602,7 @@ tiggers||triggers
 tiggered||triggered
 tipically||typically
 timeing||timing
+timming||timing
 timout||timeout
 tmis||this
 toogle||toggle
@@ -1597,8 +1626,10 @@ transision||transition
 transistioned||transitioned
 transmittd||transmitted
 transormed||transformed
+trasaction||transaction
 trasfer||transfer
 trasmission||transmission
+trasmitter||transmitter
 treshold||threshold
 triggerd||triggered
 trigerred||triggered
_

Patches currently in -mm which might be from yujiaoliang@vivo.com are

scripts-spellingtxt-add-more-spellings-corrections.patch

